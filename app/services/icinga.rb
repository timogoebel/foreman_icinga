require 'rest-client'

class Icinga
  attr_reader :client, :token, :address

  def initialize
    @address = Setting[:icinga_address]
    @token = Setting[:icinga_token]
  end

  def call(endpoint, payload = '', params = {})
    uri = icinga_url_for(endpoint, params.merge(default_params))
    parse post(uri, payload)
  rescue OpenSSL::SSL::SSLError => e
    message = "SSL Connection to Icinga failed: #{e}"
    logger.warn message
    error_response message
  end

  def logger
    Rails.logger
  end

  protected

  attr_reader :connect_params

  def connect_params
    {
      :timeout      => 3,
      :open_timeout => 3,
      :headers      => {
        :accept     => :json
      },
      :verify_ssl   => verify_ssl?,
      :ssl_ca_file  => ssl_ca_file
    }
  end

  def ssl_ca_file
    Setting[:icinga_ssl_ca_file]
  end

  def verify_ssl?
    OpenSSL::SSL::VERIFY_PEER
  end

  def default_params
    {
      'json'  => true
    }
  end

  def client(uri)
    RestClient::Resource.new(uri, connect_params)
  end

  def post(path, payload = '')
    client(path).post(payload)
  end

  def parse(response)
    if response && response.code >= 200 && response.code < 300
      return response.body.present? ? JSON.parse(response.body) : error_response(_('received empty result'))
    else
      error_response "#{response.code} #{response.message}"
    end
  rescue JSON::ParserError => e
    message = "Failed to parse icinga response: #{response} -> #{e}"
    logger.warn message
    error_response message
  end

  def error_response(message)
    {
      'status'  => 'error',
      'message' => message,
      'success' => false
    }
  end

  def icinga_url_for(route, params = {})
    base = URI.join(address, route).to_s
    return base if params.empty?
    base + '?' + params.to_query + '&token=' + token
  end
end
