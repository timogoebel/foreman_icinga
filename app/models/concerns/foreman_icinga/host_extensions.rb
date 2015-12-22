module ForemanIcinga
  module HostExtensions
    extend ActiveSupport::Concern
    included do
      before_destroy :downtime_host
      after_build :downtime_host

      has_one :icinga_status_object, :class_name => 'HostStatus::IcingaStatus', :foreign_key => 'host_id'

      scoped_search :in => :icinga_status_object, :on => :status, :rename => :icinga_status,
                    :complete_value => {
                      :ok => HostStatus::IcingaStatus::OK,
                      :warning => HostStatus::IcingaStatus::WARNING,
                      :critical => HostStatus::IcingaStatus::CRITICAL,
                      :unknown => HostStatus::IcingaStatus::UNKNOWN
                    }
    end

    def icinga_status(options = {})
      @icinga_status ||= get_status(HostStatus::IcingaStatus).to_status(options)
    end

    def icinga_status_label(options = {})
      @icinga_status_label ||= get_status(HostStatus::IcingaStatus).to_label(options)
    end

    def refresh_icinga_status
      get_status(HostStatus::IcingaStatus).refresh
    end

    def downtime_host
      logger.debug _('Setting downtime for host %s in Icinga') % name
      return false unless icinga_configured?
      return true unless icinga_enabled?

      begin
        icinga = Icinga.new
        params = {
          'host' => name,
          'comment' => 'host deleted in foreman',
          'duration' => '7200'
        }
        response = icinga.call('deployment/downtime/schedule', '', params)

        if response['status'] == 'error'
          errors.add(:base, _("Error from Icinga server: '%s'") % response['message'])
        end
      rescue => error
        message = _('Failed to set Icinga downtime for %s.') % name
        errors.add(:base, message)
        Foreman::Logging.exception(message, error)
      end
      errors.empty?
    end

    private

    def icinga_configured?
      if icinga_enabled? && (Setting[:icinga_address].blank? || Setting[:icinga_token].blank?)
        errors.add(:base,
                   _('Icinga plugin is enabled but not configured. Please configure it before trying to delete a host.'))
      end
      errors.empty?
    end

    def icinga_enabled?
      [true, 'true'].include? Setting[:icinga_enabled]
    end
  end
end
