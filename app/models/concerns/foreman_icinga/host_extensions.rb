module ForemanIcinga
  module HostExtensions
    extend ActiveSupport::Concern
    included do
      before_destroy :downtime_host
      after_build :downtime_host
    end

    def downtime_host
      logger.debug "Setting downtime for host #{name} in Icinga"
      return false unless configured?

      if enabled?
        begin
          params = {
            'host' => name,
            'token' => Setting[:icinga_token],
            'comment' => 'host deleted in foreman',
            'duration' => '5400',
            'json' => true,
          }
          uri = URI.parse("#{URI.join(Setting[:icinga_address], 'deployment/downtime/schedule')}?#{params.to_query}")
          logger.debug "Sending request to icinga: #{uri}"
          req = Net::HTTP::Post.new(uri.request_uri)
          req['Accept']   = 'application/json'
          req.body        = ''

          res             = Net::HTTP.new(uri.host, uri.port)
          res.use_ssl     = uri.scheme == 'https'
          if res.use_ssl?
            if Setting[:ssl_ca_file]
              res.ca_file = Setting[:ssl_ca_file]
              res.verify_mode = OpenSSL::SSL::VERIFY_PEER
            else
              res.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
          end
          response = res.start { |http| http.request(req) }

          case response
          when Net::HTTPSuccess
              received_hash = JSON.parse(response.body)
              logger.debug "Received response from icinga: #{received_hash.inspect}"

              if received_hash['status'] == 'error'
                errors.add(:base, _("Error from Icinga server: '#{received_hash['message']}'"))
              else
                # OK
              end
          else
            errors.add(:base, _("Could not get valid http response from icinga server: '#{response.code} #{response.message}'"))
          end

        rescue => e
          errors.add(:base, _("Could not set downtime for host in Icinga: #{e}"))
        end
        errors.empty?
      end
    end

    private

    def configured?
      if enabled? && ( Setting[:icinga_address].blank? || Setting[:icinga_token].blank? )
        errors.add(:base, _("Icinga plugin is enabled but not configured. Please configure it before trying to delete a host."))
      end
      errors.empty?
    end

    def enabled?
      [true, 'true'].include? Setting[:icinga_enabled]
    end
  end
end
