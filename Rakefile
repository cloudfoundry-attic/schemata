#!/usr/bin/env rake
require "rspec/core/rake_task"

task default: [:spec]

desc "Run all specs"
RSpec::Core::RakeTask.new("spec") do |t|
  t.rspec_opts = %w[--color --format documentation]
  t.pattern = %w[spec/**/*[Ss]pec.rb]
end
