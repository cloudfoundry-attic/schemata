require 'vcap/common'

module Schemata
  module HealthManager
    module HealthResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"     => String,
            "version"     => String,
            "healthy"     => Integer,
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
            "droplet"     => proc { VCAP.secure_uuid },
            "version"     => proc { VCAP.secure_uuid },
            "healthy"     => 1,
          }
        end
      end
    end
  end
end
