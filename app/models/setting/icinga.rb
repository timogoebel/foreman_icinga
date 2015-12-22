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
              false),

          set('icinga_affect_global_status',
              _("Icinga status will affect a host's global status when enabled"),
              true),

          set('icinga_address',
              _('Foreman will send Icingaweb2 requests to this address'),
              'https://icingahost/icingaweb2/'),

          set('icinga_token',
              _('Foreman will authenticate to icingaweb2 using this token'),
              ''),

          set('icinga_ssl_ca_file',
              _('SSL CA file that Foreman will use to communicate with icinga'),
              "#{SETTINGS[:puppetssldir]}/certs/ca.pem")
        ].compact.each { |s| create! s.update(:category => 'Setting::Icinga') }
      end
    end
  end
end
