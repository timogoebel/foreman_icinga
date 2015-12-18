module ForemanIcinga
  class Engine < ::Rails::Engine
    engine_name 'foreman_icinga'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/services"]

    initializer 'foreman_icinga.load_default_settings', :before => :load_config_initializers do |_app|
      require_dependency File.expand_path('../../../app/models/setting/icinga.rb', __FILE__) if begin
                                                                                                   Setting.table_exists?
                                                                                                 rescue
                                                                                                   (false)
                                                                                                 end
    end

    initializer 'foreman_icinga.register_plugin', :after => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_icinga do
        requires_foreman '>= 1.10'
        register_custom_status HostStatus::IcingaStatus
      end
    end

    config.to_prepare do
      Host::Managed.send :include, ForemanIcinga::HostExtensions
      HostsHelper.send(:include, ForemanIcinga::HostsHelperExt)
    end
  end
end
