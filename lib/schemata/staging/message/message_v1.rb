require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'

module Schemata
  module Staging
    module Message

      version 1 do
        include_preschemata

        define_schema do
          {
            "app_id"                    => Integer,
            "download_uri"              => String,
            "upload_uri"                 => String,
            "properties" => {
              "services" => [ {
                "label"                 => String,
                "tags"                  => [String],
                "name"                  => String,
                "credentials" => {
                  # XXX Does this schema vary by service?
                  "hostname"            => String,
                  "host"                => String,
                  "port"                => Integer,
                  "password"            => String,
                  "name"                => String,

                },
                "options"               => any,
                "plan"                  => String,
                "plan_option"          => any,
                "type"                  => String,
                "version"               => String,
                "vendor"                => String,
              } ],
              "environment"             => [String],
              "framework"               => String,
              "framework_info" => {
                "name"                  => String,
                optional("detection")   => [Hash],
                optional("runtimes")    => [Hash],
              },
              "meta" => {
                optional("debug")       => any,
                optional("console")     => any,
                optional("command")     => String,
              },
              "resources" => {
                "memory"                => Integer,
                "disk"                  => Integer,
                "fds"                   => Integer,
              },
              "runtime"                 => String,
              "runtime_info"            => Hash,
            },
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_mock_values({
          "app_id"                => 1,
          "download_uri"          => "http://foobar@172.0.0.0:100/download",
          "upload_uri"            => "http://foobar@172.0.0.0:100/upload",
          "properties" => {
            "services" => [ {
              "label"             => "mongodb-1.8",
              "tags"              => ["mongodb"],
              "name"              => "mongodb-685a",
              "credentials" => {
                "hostname"        => "172.20.208.40",
                "host"            => "172.20.208.40",
                "port"            => 25001,
                "password"        => "a2ee7245-cdee-4a4a-b426-a8258ff1b39a",
                "name"            => "2eaa7336-2696-43cd-bb96-a614740b3511",
                "username"        => "aaf31edf-b2bc-4f97-a033-7021c2528ce8",
                "db"              => "db",
                "url"             => "mongodb://aaf31edf-b2bc-4f97-a033-7021c2528ce8:a2ee7245-cdee-4a4a-b426-a8258ff1b39a@172.20.208.40:25001/db",
              },
              "options"           => {},
              "plan"              => "free",
              "plan_option"      => nil,
              "type"              => "document",
              "version"           => "1.8",
              "vendor"            => "mongodb",
            } ],
            "environment"         => [],
            "framework"           => "sinatra",
            "framework_info" => {
              "name"              => "sinatra",
              "runtimes" => [
                {"ruby18" => {
                  "default"       => true}},
                {"ruby19" => {
                  "default"       => false}},
              ],
              "detection" => [
                {"*.rb"           => "\\s*require[\\s\\(]*['\"]sinatra(/base)?['\"]"},
                {"config/environment.rb" => false}
              ],
            },
            "meta" => {
              "debug"             => nil,
              "console"           => nil,
            },
            "resources" => {
              "memory"            => 64,
              "disk"              => 2048,
              "fds"               => 256,
            },
            "runtime"             => "ruby19",
            "runtime_info" => {
              "description"       => "Ruby 1.9",
              "version"           => "1.9.2p180",
              "executable"        => "/var/vcap/packages/dea_ruby19/bin/ruby",
              "staging"           => "/var/vcap/packages/ruby/bin/ruby stage",
              "version_output"    => "1.9.2",
              "version_flag"      => "-e 'puts RUBY_VERSION'",
              "additional_checks" => "-e 'puts RUBY_PATCHLEVEL == 180'",
              "environment" => {
                "LD_LIBRARY_PATH" => "/var/vcap/packages/mysqlclient/lib/mysql:/var/vcap/packages/sqlite/lib:/var/vcap/packages/libpq/lib:/var/vcap/packages/imagemagick/lib:$LD_LIBRARY_PATH",
                "BUNDLE_GEMFILE"  => nil,
                "PATH"            => "/var/vcap/packages/imagemagick/bin:/var/vcap/packages/dea_transition/rubygems/1.9.1/bin:/var/vcap/packages/dea_ruby19/bin:/var/vcap/packages/dea_node08/bin:$PATH",
                "GEM_PATH"        => "/var/vcap/packages/dea_transition/rubygems/1.9.1:$GEM_PATH",
              },
              "status" => {
                "name"            => "current",
              },
              "series"            => "ruby19",
              "category"          => "ruby",
              "name"              => "ruby19",
            }
          }
        })
      end
    end
  end
end
