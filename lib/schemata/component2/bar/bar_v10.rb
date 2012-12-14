require 'membrane'
require 'schemata/common/msgtypebase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component2
    module Bar

      version 10 do
        define_schema do
          {
            "bar1" => String,
            "bar2" => String,
          }
        end

        define_min_version 10

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_constant :MOCK_VALUES, {
          "bar1" => "first",
          "bar2" => "second",
        }
      end
    end
  end
end
