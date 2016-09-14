# Foreman Icingaweb2 Plugin

This is a foreman plugin to interact with icingaweb2's [deployment module](https://github.com/Thomas-Gelf/icingaweb2-module-deployment).
At the moment it basically sets a downtime for a hosts that gets deleted in foreman.

This plugin is unmaintained and replaced by [Foreman Monitoring](https://github.com/theforeman/foreman_monitoring), which offers a lot more features and better integration.

# Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

# Usage

Go to Administer > Settings > Icinga and set `icinga_address` with your Icingaweb2 address, `icinga_enabled` to either true or false if you want to enable or disable Icingaweb2 integration. In addition you need to set `icinga_token` to an api token specified in the Icingaweb2 deployment module settings.

## Contributing

Fork and send a Pull Request. Thanks!

# Copyright
Copyright 2015 FILIADATA GmbH, Germany

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
