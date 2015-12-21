class Setting::Icinga < ::Setting
  BLANK_ATTRS << 'icinga_address'
  BLANK_ATTRS << 'icinga_token'

  def self.load_defaults
    if SETTINGS[:icinga].present?
      default_enabled = SETTINGS[:icinga][:enabled]
      default_address = SETTINGS[:icinga][:address]
      default_token = SETTINGS[:icinga][:token]
      default_icinga_ssl_ca_file = SETTINGS[:icinga][:icinga_ssl_ca_file]
    end

    default_enabled = false if default_enabled.nil?
    default_address ||= 'https://icingahost/icingaweb2/'
    default_token ||= ''
    default_icinga_ssl_ca_file ||= "#{SETTINGS[:puppetssldir]}/certs/ca.pem"

    Setting.transaction do
      [
        set('icinga_enabled', _("Integration with Icingaweb2, enabled will set a downtime for a host when it's deleted in Foreman"), default_enabled)
      ].compact.each { |s| create s.update(:category => 'Setting::Icinga') }
    end

    Setting.transaction do
      [
        set('icinga_address', _('Foreman will send Icingaweb2 requests to this address'), default_address)
      ].compact.each { |s| create s.update(:category => 'Setting::Icinga') }
    end

    Setting.transaction do
      [
        set('icinga_token', _('Foreman will authenticate to icingaweb2 using this token'), default_token)
      ].compact.each { |s| create s.update(:category => 'Setting::Icinga') }
    end

    Setting.transaction do
      [
        set('icinga_ssl_ca_file', _('SSL CA file that Foreman will use to communicate with icinga'), default_icinga_ssl_ca_file)
      ].compact.each { |s| create s.update(:category => 'Setting::Icinga') }
    end
  end
end
