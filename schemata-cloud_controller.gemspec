require File.expand_path('../lib/schemata/cloud_controller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "schemata-cloud_controller"
  gem.version = Schemata::CloudController::VERSION
  gem.date = '2012-10-16'
  gem.summary = 'validation for cloudfoundry cloud_controller messages'
  gem.homepage = 'http://www.cloudfoundry.org'
  gem.authors = ['dsabeti']
  gem.email = ['support@cloudfoundry.org']
  gem.description = <<-EOT
    Specify schema for cloud controller messages and validate messages
        against the defined schema.
    EOT
  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("membrane")
  gem.add_development_dependency("ci_reporter")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end
