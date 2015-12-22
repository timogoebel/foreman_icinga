require File.expand_path('../lib/foreman_icinga/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_icinga'
  s.version     = ForemanIcinga::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Timo Goebel']
  s.email       = ['timo.goebel@dm.de']
  s.homepage    = 'http://www.github.com/FILIADATAGmbH/foreman_icinga'
  s.summary     = 'This is a foreman plugin to interact with icingaweb2 deployment module.'
  s.description = 'Set a downtime for hosts after they are deleted in Foreman.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rest-client'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
