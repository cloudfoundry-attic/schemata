require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module Dea
    module StartRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"               => enum(String, Integer),
            "name"                  => String,
            "uris"                  => [String],
            "runtime"               => String,
            "runtime_info" => {
              "description"         => String,
              "version"             => String,
              "executable"          => String,
              "staging"             => String,
              "version_output"      => String,
              "version_flag"        => String,
              "additional_checks"   => String,
              "environment"         => Hash,
              "status" => {
                "name"              => String
              },
              "series"              => String,
              "category"            => String,
              "name"                => String
            },
            "framework"             => String,
            "prod"                  => bool,
            "sha1"                  => String,
            "executableFile"        => String,
            "executableUri"         => String,
            "version"               => String,
            "services" => [{
              "label"               => String,
              optional("tags")                => [String],
              "name"                => String,
              "credentials" => {
                "hostname"          => String,
                "host"              => String,
                "port"              => Integer,
                "username"          => String,
                "password"          => String,
                "name"              => String,
                optional("db")      => String,
                optional("url")     => String,
                optional("vhost")   => String,
                optional("user")    => String,
                optional("pass")    => String,
              },
              "plan"                => String,
              optional("plan_option")   => enum(String, NilClass),
              optional("type")          => String,
              "version"             => String,
              "vendor"              => String
            }],
            "limits" => {
              "mem"                 => Integer,
              "disk"                => Integer,
              "fds"                 => Integer
            },
            "env"                   => [String],
            "cc_partition"          => String,
            optional("debug")         => any,
            "console"               => any,
            "index"                 => Integer,
            optional("flapping")    => bool,
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_mock_values do
          {
            "droplet" => proc { VCAP.secure_uuid },
            "name" => "foo",
            "uris" => ["foo.vcap.me"],
            "runtime" => "ruby18",
            "runtime_info" => {
              "description" => "Ruby 1.8",
              "version" => "1.8.7p357",
              "executable" => "/var/vcap/packages/dea_ruby18/bin/ruby",
              "staging" => "/var/vcap/packages/ruby/bin/ruby stage",
              "version_output" => "1.8.7",
              "version_flag" => "-e 'puts RUBY_VERSION'",
              "additional_checks" => "-e 'puts RUBY_PATCHLEVEL == 357'",
              "environment" => {
                "LD_LIBRARY_PATH" => "/var/vcap/packages/mysqlclient/lib/mysql:/var/vcap/packages/sqlite/lib:/var/vcap/packages/libpq/lib:/var/vcap/packages/imagemagick/lib:$LD_LIBRARY_PATH",
                "BUNDLE_GEMFILE" => nil,
                "PATH" => "/var/vcap/packages/imagemagick/bin:/var/vcap/packages/dea_transition/rubygems/1.8/bin:/var/vcap/packages/dea_ruby18/bin:/var/vcap/packages/dea_node08/bin:$PATH",
                "GEM_PATH" => "/var/vcap/packages/dea_transition/rubygems/1.8:$GEM_PATH"
              },
              "status" => {
                "name" => "current"
              },
              "series" => "ruby18",
              "category" => "ruby",
              "name" => "ruby18"
            },
            "framework" => "rails3",
            "prod" => false,
            "sha1" => "1487604bbdd3e29351a6f13570628a703dc032a4",
            "executableFile" => "/var/vcap/shared/droplets/droplet_123",
            "executableUri" => "http://172.20.208.195:9022/staged_droplets/123/1487604bbdd3e29351a6f13570628a703dc032a4",
            "version" => "1487604bbdd3e29351a6f13570628a703dc032a4-1",
            "services"=> [],
            "limits" => {
              "mem" => 256,
              "disk" => 2048,
              "fds" => 256
            },
            "env" => [],
            "cc_partition" => "default",
            "debug" => nil,
            "console" => nil,
            "index" => 0,
            "flapping" => false,
          }
        end
      end
    end
  end
end
