require 'vcap/common'

module Schemata
  module HealthManager
    module HealthRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplets" => [{
              "droplet"       => String,
              "version"       => String,
            }]
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
            "droplets" => proc do
            [{
              "droplet" => VCAP.secure_uuid,
              "version" => VCAP.secure_uuid,
            }]
            end
          }
        end
      end
    end
  end
end
