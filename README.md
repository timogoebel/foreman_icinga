# Foreman Icingaweb2 Plugin

This is a foreman plugin to interact with icingaweb2's [deployment module](https://github.com/Thomas-Gelf/icingaweb2-module-deployment).
At the moment it basically sets a downtime for a hosts that gets deleted in foreman.

# Installation:

**From packages**

Set up the appropriate repository by following [these instructions](http://theforeman.org/manuals/1.9/index.html#3.3InstallFromPackages)

RPM users can install the "ruby193-rubygem-foreman_icinga" or "rubygem-foreman_icinga" packages.

Deb users can install the "ruby-foreman_icinga" package.

**From Rubygems**

Add to bundler.d/Gemfile.local.rb as:

    gem 'foreman_icinga'

then update & restart Foreman:

    bundle update


# Usage:

Go to Administer > Settings > Icinga and set `icinga_address` with your Icingaweb2 address, `icinga_enabled` to either true or false if you want to enable or disable Icingaweb2 integration. In addition you need to set `icinga_token` to an api token specified in the Icingaweb2 deployment module settings.

# Copyright:
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
