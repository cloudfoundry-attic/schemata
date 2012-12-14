module Schemata
  module DEA
    module UpdateRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            "droplet" => enum(String, Integer),
            "uris"    => [String]
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
            "droplet" => proc { VCAP.secure_uuid },
            "uris"    => ["foo.vcap.me"],
          }
        end
      end
    end
  end
end
