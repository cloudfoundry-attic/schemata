require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module Dea
    module HelloMessage
      version 1 do
        include_preschemata

        define_schema do
          {
            "id"        => String,
            "ip"        => String,
            "port"      => Integer,
            "version"   => String,
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
            "id"        => proc { VCAP.secure_uuid },
            "ip"        => '127.0.0.1',
            "port"      => 80,
            "version"   => '0.1.0',
          }
        end
      end
    end
  end
end
