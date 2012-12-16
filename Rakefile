#!/usr/bin/env rake
require "ci/reporter/rake/rspec"
require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new("spec") do |t|
  t.rspec_opts = %w[--color --format documentation]
  case ENV["BUNDLE_GEMFILE"]
  when "Gemfile.router"
    t.pattern = ['spec/router_spec.rb', 'spec/common/*_spec.rb']
  when "Gemfile.dea"
    t.pattern = ['spec/dea_spec.rb', 'spec/common/*_spec.rb']
  when "Gemfile.staging"
    t.pattern = ['spec/staging_spec.rb', 'spec/common/*_spec.rb']
  when "Gemfile.cloud_controller"
    t.pattern = ['spec/cloud_controller_spec.rb', 'spec/common/*_spec.rb']
  when "Gemfile.health_manager"
    t.pattern = ['spec/health_manager_spec.rb', 'spec/common/*_spec.rb']
  end
end

desc "Run all specs and provide output for ci"
RSpec::Core::RakeTask.new("spec:ci" => "ci:setup:rspec") do |t|
  t.rspec_opts = %w[--no-color --format documentation]
end
