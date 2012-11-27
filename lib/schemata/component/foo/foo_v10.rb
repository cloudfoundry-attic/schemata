require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Foo

      version 10 do
        define_schema do
          {
            "foo1" => String,
            "foo2" => Integer,
          }
        end

        define_min_version 10

        define_upvert do |old_data|
          raise NotImplementedError.new
        end

        define_generate_old_fields do |msg_obj|
          raise NotImplementedError.new
        end

        define_mock_values({
          "foo1" => "foo",
          "foo2" => 2
        })
      end
    end
  end
end
