class Setting
  class Icinga < ::Setting
    BLANK_ATTRS << 'icinga_address'
    BLANK_ATTRS << 'icinga_token'

    def self.load_defaults
      # Check the table exists
      return unless super

      Setting.transaction do
        [
          set('icinga_enabled',
              _("Integration with Icingaweb2, enabled will set a downtime for a host when it's deleted in Foreman"),
              false, N_('Icinga enabled?')),

          set('icinga_address',
              _('Foreman will send Icingaweb2 requests to this address'),
              'https://icingahost/icingaweb2/', N_('Icinga address')),

          set('icinga_token',
              _('Foreman will authenticate to icingaweb2 using this token'),
              '', N_('Icinga Token')),

          set('icinga_ssl_ca_file',
              _('SSL CA file that Foreman will use to communicate with icinga'),
              "#{SETTINGS[:puppetssldir]}/certs/ca.pem", N_('Icinga SSL CA file')),

          set('icinga_affect_global_status',
              _("Icinga status will affect a host's global status when enabled"),
              true, N_('Icinga should affect global status')),

          set('icinga_ignore_failed_action',
              _("Host will be deleted in Foreman even though Foreman was unable to set a downtime in Icinga"),
              false, N_('Ignore failed icinga requests'))
        ].compact.each { |s| create! s.update(:category => 'Setting::Icinga') }
      end
    end
  end
end
