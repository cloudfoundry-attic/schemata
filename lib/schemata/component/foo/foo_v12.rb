require 'membrane'
require 'schemata/common/msgtypebase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component
    module Foo

      version 12 do
        define_schema do
          {
            "foo1" => String,
            "foo2" => Integer,
            "foo3" => [Integer],
          }
        end

        define_min_version 10

        define_upvert do |old_data|
          new_data = Schemata::Helpers.deep_copy(old_data)
          new_data["foo3"] = [old_data["foo3"]]
          new_data
        end

        define_generate_old_fields do |msg_obj|
          first = msg_obj.foo3.length > 0 ? msg_obj.foo3[0] : 1
          old_fields = {"foo3" => first}
        end

        define_mock_values({
          "foo1" => "foo",
          "foo2" => 2,
          "foo3" => lambda { [Random.rand(11)] },
        })
      end
    end
  end
end
