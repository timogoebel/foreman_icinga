# This calls the main test_helper in Foreman-core
require 'test_helper'

# Add plugin to FactoryGirl's paths
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.reload

def setup_default_settings
  mock_icinga_setting :icinga_address, 'http://example.com/'
  mock_icinga_setting :icinga_token, '123456'
  mock_icinga_setting :icinga_enabled, true
  mock_icinga_setting :icinga_ignore_failed_action, false
end

def mock_icinga_setting(name, value)
  FactoryGirl.create(:setting,
                     :name => name.to_s,
                     :value => value,
                     :category => 'Setting::Icinga')
end
