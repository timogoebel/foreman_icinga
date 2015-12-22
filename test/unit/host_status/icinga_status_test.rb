require 'test_plugin_helper'

class IcingaStatusTest < ActiveSupport::TestCase
  setup do
    @host = FactoryGirl.create(:host)
    @status = HostStatus::IcingaStatus.new(:host => @host)
  end

  test 'is valid' do
    assert_valid @status
  end

  test '#relevant? is only for hosts not in build mode' do
    @host.build = false
    assert @status.relevant?

    @host.build = true
    refute @status.relevant?
  end

  test '#to_label returns string representation of status code' do
    assert_kind_of String, @status.to_label
  end

  test '#to_global returns global OK when disabled by setting' do
    mock_icinga_setting :icinga_affect_global_status, false
    @status.status = HostStatus::IcingaStatus::WARNING
    assert_equal HostStatus::Global::OK, @status.to_global
  end

  test '#to_global returns correct global status' do
    mock_icinga_setting :icinga_affect_global_status, true
    @status.status = HostStatus::IcingaStatus::OK
    assert_equal HostStatus::Global::OK, @status.to_global

    @status.status = HostStatus::IcingaStatus::WARNING
    assert_equal HostStatus::Global::WARN, @status.to_global

    @status.status = HostStatus::IcingaStatus::CRITICAL
    assert_equal HostStatus::Global::ERROR, @status.to_global

    @status.status = HostStatus::IcingaStatus::UNKNOWN
    assert_equal HostStatus::Global::OK, @status.to_global
  end
end
