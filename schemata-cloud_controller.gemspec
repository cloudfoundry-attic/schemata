require File.expand_path('../lib/schemata/cloud_controller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "schemata-cloud_controller"
  gem.version = Schemata::CloudController::VERSION
  gem.date = '2012-11-21'
  gem.summary = 'validation for cloundfoundry cloud controller messages'
  gem.homepage = 'http://www.cloudfoundry.org'
  gem.authors = ['dsabeti']
  gem.email = ['support@cloudfoundry.org']
  gem.description = <<-EOT
    Specify schema for cloud controller messages and validate messages
      against defined schema
  EOT
  gem.files = Dir.glob("**/*").select do |f|
    f =~ /lib\/schemata\/(cloud_controller|common|helpers)/
  end
  gem.executables = `git ls-files`.split($\).grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = `git ls-files`.split($\).grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("membrane")
  gem.add_dependency("yajl-ruby")
  gem.add_development_dependency("ci_reporter")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end
