require 'vcap/common'

module Schemata
  module HealthManager
    module StatusCrashedResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "instances" => [{
              "instance"        => String,
              "since"           => enum(Integer, Float, NilClass),
            }]
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_upvert do |msg_obj|
          raise NotImplementedError.new
        end

        define_mock_values do
          {
            "instances" => proc do
              [{
                "instance" => VCAP.secure_uuid,
                "since"    => Time.now.to_i,
              }]
            end
          }
        end
      end
    end
  end
end
