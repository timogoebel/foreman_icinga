module ForemanIcinga
  module HostsHelperExt
    extend ActiveSupport::Concern

    included do
      alias_method_chain :host_title_actions, :icinga
    end

    def host_title_actions_with_icinga(host)
      title_actions(
        button_group(
          link_to(_('Icinga'), icinga_show_host_path(host), :target => '_blank')
        )
      )
      host_title_actions_without_icinga(host)
    end

    def icinga_show_host_path(host)
      params = {
        :host => host.name
      }
      icinga_url_for('monitoring/host/show', params)
    end

    def icinga_url_for(route, params = {})
      base = URI.join(Setting[:icinga_address], route).to_s
      return base if params.empty?
      base + '?' + params.to_query
    end
  end
end
