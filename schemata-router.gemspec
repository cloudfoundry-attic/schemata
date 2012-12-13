require File.expand_path('../lib/schemata/router/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "schemata-router"
  gem.version = Schemata::Router::VERSION
  gem.date = '2012-12-19'
  gem.summary = 'validation for cloundfoundry Router messages'
  gem.homepage = 'http://www.cloudfoundry.org'
  gem.authors = ['dsabeti']
  gem.email = ['support@cloudfoundry.org']
  gem.description = <<-EOT
    Specify schema for Router messages and validate messages
      against defined schema
  EOT
  gem.files = Dir.glob("**/*").select do |f|
    f =~ /lib\/schemata\/(router|common|helpers)/
  end
  gem.executables = `git ls-files`.split($\).grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = `git ls-files`.split($\).grep(%r{^spec/(router/|common/|support/|spec_helper.rb)})
  gem.require_paths = ["lib"]

  gem.add_dependency("membrane")
  gem.add_dependency("yajl-ruby")
  gem.add_dependency('vcap_common')
  gem.add_development_dependency("ci_reporter")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end
