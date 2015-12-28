require 'test_plugin_helper'

class IcingaHostExtensionsTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryGirl.build(:user, :admin)
    setup_default_settings
  end

  context 'when icinga is configured and enabled' do
    setup do
      Setting[:icinga_enabled] = true
      Setting[:icinga_ignore_failed_action] = false
    end

    test 'it should be configured and enabled' do
      host = Host.new
      assert host.send(:icinga_configured?)
      assert host.send(:icinga_enabled?)
    end

    test 'it should set a downtime when host is deleted' do
      host = FactoryGirl.create(:host)
      mock_successful_icinga_result
      assert host.destroy
      assert_empty host.errors
    end

    test 'it should not delete host and add errors when icinga_ignore_failed_action is false' do
      host = FactoryGirl.create(:host)
      mock_failed_icinga_result
      refute host.destroy
      assert_includes host.errors[:base], 'Error from Icinga server: \'A random error occured.\''
    end

    test 'it should delete host add no errors when icinga_ignore_failed_action is true' do
      Setting[:icinga_ignore_failed_action] = true
      host = FactoryGirl.create(:host)
      mock_failed_icinga_result
      assert host.destroy
      assert_empty host.errors
    end
  end

  def mock_successful_icinga_result
      icinga_result = {
        'success' => true,
        'host' => 'localhost',
        'downtime_comment' => 'deployment',
        'downtime_duration' => 1200,
        'downtime_start' => 1427989338,
        'downtime_end' => 1427990238
      }
      Icinga.any_instance.expects(:call).once.returns(icinga_result)
  end

  def mock_failed_icinga_result
      icinga_result = {
        'status' => 'error',
        'message' => 'A random error occured.',
      }
      Icinga.any_instance.expects(:call).once.returns(icinga_result)
  end
end
