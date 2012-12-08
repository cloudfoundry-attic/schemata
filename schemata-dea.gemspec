require File.expand_path('../lib/schemata/dea/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = "schemata-dea"
  gem.version = Schemata::DEA::VERSION
  gem.date = '2012-12-10'
  gem.summary = 'validation for cloundfoundry DEA messages'
  gem.homepage = 'http://www.cloudfoundry.org'
  gem.authors = ['dsabeti']
  gem.email = ['support@cloudfoundry.org']
  gem.description = <<-EOT
    Specify schema for DEA messages and validate messages
      against defined schema
  EOT
  gem.files = Dir.glob("**/*").select do |f|
    f =~ /lib\/schemata\/(dea|common|helpers)/
  end
  gem.executables = `git ls-files`.split($\).grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = `git ls-files`.split($\).grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("membrane")
  gem.add_dependency("yajl-ruby")
  gem.add_dependency('vcap_common')
  gem.add_development_dependency("ci_reporter")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end
