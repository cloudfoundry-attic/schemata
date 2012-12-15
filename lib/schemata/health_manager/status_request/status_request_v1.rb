require 'vcap/common'

module Schemata
  module HealthManager
    module StatusRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"             => String,
            "state"               => String,
            optional("version")   => String,
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
            "state"   => "FLAPPING",
            "version" => proc { VCAP.secure_uuid },
          }
        end
      end
    end
  end
end
