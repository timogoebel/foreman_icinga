require 'test_plugin_helper'

class IcingaTest < ActiveSupport::TestCase
  setup do
    setup_default_settings
    @icinga = Icinga.new
  end

  test '#icinga_url_for should return valid urls' do
    assert_equal 'http://example.com/test/bla&token=123456',
                 @icinga.send('icinga_url_for', 'test/bla')
    assert_equal 'http://example.com/test/blubb?param=1&token=123456',
                 @icinga.send('icinga_url_for', 'test/blubb', 'param' => '1')
  end

  def fake_response(data)
    net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
    RestClient::Response.create(data, net_http_resp, nil)
  end

  test 'should correctly parse response' do
    @icinga.expects(:post)
      .with('http://example.com/health?host=example.com&json=true&token=123456', '')
      .returns(fake_response(JSON('healthy' => 'true')))
    response = @icinga.call('health', '', 'host' => 'example.com')
    assert_kind_of Hash, response
    assert response['healthy']
  end

  test 'should return error message when result is empty' do
    @icinga.expects(:post)
      .with('http://example.com/health?host=example.com&json=true&token=123456', '')
      .returns(fake_response(''))
    response = @icinga.call('health', '', 'host' => 'example.com')
    assert_kind_of Hash, response
    assert_equal 'error', response['status']
    assert_equal 'received empty result', response['message']
  end
end
