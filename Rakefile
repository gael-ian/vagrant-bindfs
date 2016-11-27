require "rubygems"
require "bundler/setup"
require "rspec/core/rake_task"

# Immediately sync all stdout
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file
Dir.chdir(File.expand_path("../", __FILE__))

# Installs the tasks for gem creation
Bundler::GemHelper.install_tasks

# Install the `spec` task so that we can run tests
RSpec::Core::RakeTask.new

# Default task is to run the unit tests
task :default => "spec"
