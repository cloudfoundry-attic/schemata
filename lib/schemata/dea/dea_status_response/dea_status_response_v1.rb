require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module DeaStatusResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "id"              => String,
            "ip"              => String,
            "port"            => Integer,
            "version"         => String,
            "max_memory"      => Integer,
            "used_memory"     => Integer,
            "reserved_memory" => Integer,
            "num_clients"     => Integer,
          }
        end

        define_min_version 1

        define_upvert do |old_data|
          raise NotImplmenetedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_mock_values do
          {
            "id"              => proc { VCAP.secure_uuid },
            "ip"              => '127.0.0.1',
            "port"            => 80,
            "version"         => '0.1.0',

            "max_memory"      => 1024,
            "used_memory"     => 256,
            "reserved_memory" => 512,
            "num_clients"     => 1,
          }
        end
      end
    end
  end
end
