module ForemanIcinga
  class Engine < ::Rails::Engine

    engine_name 'foreman_icinga'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    initializer 'foreman_icinga.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/icinga.rb", __FILE__) if (Setting.table_exists? rescue(false))
    end

    initializer 'foreman_icinga.register_plugin', :after => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_icinga do
        requires_foreman '>= 1.0'
      end
    end

    config.to_prepare do
      if SETTINGS[:version].to_s.to_f >= 1.2
        # Foreman 1.2
        Host::Managed.send :include, ForemanIcinga::HostExtensions
      else
        # Foreman < 1.2
        Host.send :include, ForemanIcinga::HostExtensions
      end
    end
  end
end
