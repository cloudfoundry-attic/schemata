require 'vcap/common'

module Schemata
  module Dea
    module DiscoverRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"               => enum(String, Integer),
            "limits" => {
              "mem"                 => Integer,
              "disk"                => Integer,
              "fds"                 => Integer,
            },
            "name"                  => String,
            "runtime_info" => {
              "description"         => String,
              "version"             => String,
              "executable"          => String,
              "staging"             => String,
              "version_output"      => String,
              "version_flag"        => String,
              "additional_checks"   => String,
              "environment" => {
                "LD_LIBRARY_PATH"   => String,
                "BUNDLE_GEMFILE"    => enum(String, NilClass),
                "PATH"              => String,
                "GEM_PATH"          => String,
              },
              "status" => {
                "name"              => String
              },
              "series"              => String,
              "category"            => String,
              "name"                => String
            },
            "runtime"               => String,
            "prod"                  => bool,
            "sha"                   => String,
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
            "limits" => {
              "mem" => 128,
              "disk" => 2048,
              "fds" => 256
            },
            "name" => "foo",
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
            "runtime" => "ruby18",
            "prod" => false,
            "sha" => proc { VCAP.secure_uuid }
          }
        end
      end
    end
  end
end
