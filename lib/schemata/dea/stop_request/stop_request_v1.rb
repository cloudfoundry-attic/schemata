require 'vcap/common'

module Schemata
  module DEA
    module StopRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"               => String,
            optional("version")     => String,
            optional("instances")   => [String],
            optional("indices")     => [Integer]
          }
        end

        define_min_version 1

        define_upvert do |old_message|
          raise NotImplementedError.new
        end

        define_generate_old_fields do
          raise NotImplementedError.new
        end

        define_mock_values do
          {
            "droplet" => proc { VCAP.secure_uuid },
            "version" => proc { VCAP.secure_uuid },
            "instances" => proc { [VCAP.secure_uuid] },
            "indices" => [0, 1, 2],
          }
        end
      end
    end
  end
end
