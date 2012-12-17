require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'

module Schemata
  module Dea
    module AdvertiseMessage
      version 1 do
        include_preschemata

        define_schema do
          {
            "id" => String,
            "runtimes" => [String],
            "available_memory" => Integer,
            "prod" => bool,
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
            "id" => proc { VCAP.secure_uuid },
            "runtimes"  => ["ruby18", "ruby19", "java"],
            "available_memory" => 1024,
            "prod"      => false,
          }
        end
      end
    end
  end
end
