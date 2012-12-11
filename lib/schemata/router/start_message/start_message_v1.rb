module Schemata
  module Router
    module StartMessage
      version 1 do
        include_preschemata

        define_schema do
          {
            "id" => String,
            "version" => String,
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
            "id" => proc { VCAP.secure_uuid },
            "version" => "0.1.0",
          }
        end
      end
    end
  end
end
