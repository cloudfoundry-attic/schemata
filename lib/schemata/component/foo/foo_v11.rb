require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Foo

      version 11 do
        define_schema do
          {
            "foo1" => String,
            "foo2" => Integer,
            "foo3" => Integer,
          }
        end

        define_min_version 10

        define_constant :DEFAULT_FOO3, 1

        define_upvert do |old_data|
          new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
          new_data["foo3"] = self::DEFAULT_FOO3
          new_data
        end

        define_generate_old_fields do |msg_obj|
          {}
        end

        define_mock_values({
          "foo1" => "foo",
          "foo2" => 2,
          "foo3" => 3
        })
      end
    end
  end
end
