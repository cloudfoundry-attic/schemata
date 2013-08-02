require File.expand_path('../lib/schemata/core/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "schemata-core"
  gem.version = Schemata::Core::VERSION
  gem.date = '2012-10-16'
  gem.summary = 'validation for mock messages from "component"'
  gem.homepage = 'http://www.cloudfoundry.org'
  gem.authors = ['dsabeti']
  gem.email = ['support@cloudfoundry.org']
  gem.description = <<-EOT
    Specify schema for messages to a hypothetical component and validate messages
        against the defined schema.
    EOT
  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("membrane")
  gem.add_dependency("yajl-ruby")
  gem.add_development_dependency("ci_reporter")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end
