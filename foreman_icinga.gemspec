require 'rake'
Gem::Specification.new do |s|
  s.name        = 'foreman_icinga'
  s.version     = '0.0.1'
  s.date        = '2015-09-28'
  s.license     = 'GPL-3.0'
  s.summary     = 'This is a foreman plugin to interact with icingaweb2 deployment module.'
  s.description = 'Set a downtime for hosts after they are deleted in Foreman.'
  s.authors     = ['Timo Goebel']
  s.email       = 'timo.goebel@dm.de'
  s.files       = FileList['app/**/**'].to_a + FileList['lib/**/**'].to_a
  s.homepage    = 'http://www.github.com/FILIADATAGmbH/foreman_icinga'
end
