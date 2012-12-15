require 'vcap/common'

module Schemata
  module CloudController
    module HmStartRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"       => String,
            "op"            => "START",
            "last_updated"  => Integer,
            "version"       => String,
            "indices"       => [Integer],
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
            "droplet"       => proc { VCAP.secure_uuid },
            "op"            => "START",
            "last_updated"  => proc { Time.now.to_i },
            "version"       => proc { VCAP.secure_uuid },
            "indices"       => [0, 1]
          }
        end
      end
    end
  end
end
