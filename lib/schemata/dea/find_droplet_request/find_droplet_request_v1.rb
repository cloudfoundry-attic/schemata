require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module DEA
    module FindDropletRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"   => String,
            "states"    => [String],
            "version"   => String,

            optional("path")          => String,
            optional("instance_ids")  => [String],
            optional("indices")       => [Integer],
            optional("include_stats") => bool,
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|

        end

        define_mock_values do
          {
            "droplet"       => proc { VCAP.secure_uuid },
            "states"        => ["RUNNING"],
            "version"       => "0.1.0",

            "path"          => "logs/staging.log",
            "instance_ids"  => proc { [VCAP.secure_uuid] },
            "indices"       => [0],
            "include_stats" => false,
          }
        end
      end
    end
  end
end
