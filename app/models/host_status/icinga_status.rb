module HostStatus
  class IcingaStatus < HostStatus::Status
    OK = 0
    WARNING = 1
    CRITICAL = 2
    UNKNOWN = 3

    def relevant?(options = {})
      host_not_in_build? && host_known_in_icinga?
    end

    def to_status(_options = {})
      parse_host_status call_icinga
    end

    def to_global(_options = {})
      return HostStatus::Global::OK unless should_affect_global_status?
      case status
      when OK
        HostStatus::Global::OK
      when WARNING
        HostStatus::Global::WARN
      when CRITICAL
        HostStatus::Global::ERROR
      else
        HostStatus::Global::OK
      end
    end

    def self.status_name
      N_('Icinga Status')
    end

    def to_label(_options = {})
      case status
      when OK
        N_('OK')
      when WARNING
        N_('Warning')
      when CRITICAL
        N_('Critical')
      else
        N_('Unknown')
      end
    end

    def host_not_in_build?
      host && !host.build
    end

    def host_known_in_icinga?
      true
    end

    def should_affect_global_status?
      Setting[:icinga_affect_global_status]
    end

    def client
      @icinga ||= Icinga.new
    end

    def call_icinga
      client.call('deployment/health/check', {}, {'host' => host.name}, :get)
    rescue RestClient::Unauthorized
      nil
    end

    def parse_host_status(response)
      return UNKNOWN if response.nil?
      return UNKNOWN if response.key?('status') && response['status'] == 'error'
      return UNKNOWN unless response.key?('healthy')
      if response['healthy']
        OK
      else
        WARNING
      end
    end
  end
end
