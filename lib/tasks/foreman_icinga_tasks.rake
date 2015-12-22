# Tests
namespace :test do
  desc 'Test ForemanIcinga'
  Rake::TestTask.new(:foreman_icinga) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
  end
end

namespace :foreman_icinga do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_icinga) do |task|
        task.patterns = ["#{ForemanIcinga::Engine.root}/app/**/*.rb",
                         "#{ForemanIcinga::Engine.root}/lib/**/*.rb",
                         "#{ForemanIcinga::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_icinga'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_icinga'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:foreman_icinga'].invoke
    Rake::Task['foreman_icinga:rubocop'].invoke
  end
end
