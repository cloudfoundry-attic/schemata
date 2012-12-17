require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module Dea
    module FindDropletResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "dea"                     => String,
            "droplet"                 => String,
            "version"                 => String,
            "instance"                => String,
            "index"                   => Integer,
            "state"                   => String,
            "state_timestamp"         => Float,
            "file_uri"                => String,
            "credentials"             => [String],
            "staged"                  => String,

            optional("file_uri_v2")   => String,

            optional("debug_ip")      => String,
            optional("debug_port")    => Integer,

            optional("console_ip")    => String,
            optional("console_port")  => Integer,

            optional("stats") => {
              "name"                  => String,
              "uris"                  => [String],
              "host"                  => String,
              "port"                  => Integer,
              "uptime"                => Integer,
              "mem_quota"             => Integer,
              "disk_quota"            => Integer,
              "fds_quota"             => Integer,
              "usage" => {
                "time"                => String,
                "cpu"                 => Integer,
                "mem"                 => Integer,
                "disk"                => Integer,
              },
            },
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplmentedError.new
        end

        define_mock_values do
          instance_id = VCAP.secure_uuid

          {
            "dea"                   => VCAP.secure_uuid,
            "droplet"               => "#{Random.rand(1000)}",
            "version"               => VCAP.secure_uuid,
            "instance"              => instance_id,
            "index"                 => 0,
            "state"                 => "RUNNING",
            "state_timestamp"       => Time.now.to_f,
            "file_uri"              => "http://172.20.208.11:80/instances",
            "credentials"           => [VCAP.secure_uuid, VCAP.secure_uuid],
            "staged"                => "/#{instance_id}",

            "file_uri_v2"           => "http://#{VCAP.secure_uuid}.vcap.me/instance_paths/#{instance_id}/\
?timestamp=#{Time.now.to_i}&hmac=cfa11450527aeb&path=",

            "debug_ip"              => "127.0.0.1",
            "debug_port"            => 80,

            "console_ip"            => "127.0.0.1",
            "console_port"          => 80,

            "stats" => {
              "name"                => "foo",
              "uris"                => ["foo.com", "bar.com"],
              "host"                => "127.0.0.1",
              "port"                => 80,
              "uptime"              => 1,
              "mem_quota"           => 5,
              "disk_quota"          => 10,
              "fds_quota"           => 15,
              "usage" => {
                "time"              => Time.now.to_s,
                "cpu"               => 0,
                "mem"               => 0,
                "disk"              => 0,
              },
            },
          }
        end
      end
    end
  end
end
