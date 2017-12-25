require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen/rake_tasks'

Kitchen::RakeTasks.new

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

task default: ['style', 'kitchen:all']
