module ForemanIcinga
  class Engine < ::Rails::Engine
    engine_name 'foreman_icinga'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/services"]

    initializer 'foreman_icinga.load_default_settings', :before => :load_config_initializers do |_app|
      if begin
        Setting.table_exists?
      rescue
        false
      end
        require_dependency File.expand_path('../../../app/models/setting/icinga.rb', __FILE__)
      end
    end

    initializer 'foreman_icinga.register_plugin', :after => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_icinga do
        requires_foreman '>= 1.10'
        register_custom_status HostStatus::IcingaStatus
      end
    end

    config.to_prepare do
      begin
        Host::Managed.send :include, ForemanIcinga::HostExtensions
        HostsHelper.send(:include, ForemanIcinga::HostsHelperExt)
      rescue => e
        Rails.logger.warn "ForemanIcinga: skipping engine hook (#{e})"
      end
    end

    initializer 'foreman_icinga.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_icinga'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
