require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module Dea
    module ExitMessage
      version 1 do
        include_preschemata

        define_schema do
          {
            "cc_partition"    => String,
            "droplet"         => String,
            "version"         => String,
            "instance"        => String,
            "index"           => Integer,
            "reason"          => String,

            optional("crash_timestamp") => Integer,
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
            "cc_partition"      => "default",
            "droplet"           => proc { VCAP.secure_uuid },
            "version"           => "0.1.0",
            "instance"          => proc { VCAP.secure_uuid },
            "index"             => Random.rand(100),
            "reason"            => "STOPPED",

            "crash_timestamp"   => Time.now.to_i,
          }
        end
      end
    end
  end
end
