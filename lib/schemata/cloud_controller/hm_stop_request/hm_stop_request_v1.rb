require 'vcap/common'

module Schemata
  module CloudController
    module HmStopRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet"       => String,
            "op"            => "STOP",
            "last_updated"  => Integer,
            "instances"     => [String]
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
            "op"            => "STOP",
            "last_updated"  => proc { Time.now.to_i},
            "instances"     => proc {[ VCAP.secure_uuid ]}
          }
        end
      end
    end
  end
end
