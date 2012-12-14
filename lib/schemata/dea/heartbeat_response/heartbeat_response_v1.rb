require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module DEA
    module HeartbeatResponse

      version 1 do
        include_preschemata

        define_schema do
          {
            "droplets" => [{
              optional("cc_partition") => enum(String, NilClass),
              "droplet"             => String,
              "version"             => String,
              "instance"            => String,
              "index"               => Integer,
              "state"               => String,
              "state_timestamp"     => Float,
            }],
            "dea"                   => String,
            "prod"                  => bool,
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
            "droplets" => [{
              "cc_partition"    => "default",
              "droplet"         => "#{Random.rand(1000)}",
              "version"         => VCAP.secure_uuid,
              "instance"        => VCAP.secure_uuid,
              "index"           => 0,
              "state"           => "RUNNING",
              "state_timestamp" => Time.now.to_f
            }],
            "dea"               => VCAP.secure_uuid,
            "prod"              => false,
          }
        end
      end

    end
  end
end
