require 'membrane'
require 'schemata/common/msgtypebase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component
    module Foo

      version 13 do
        define_schema do
          {
            "foo1" => String,
            "foo3" => [Integer],
            "foo4" => String,
          }
        end

        define_min_version 13

        define_upvert do |old_data|
          new_data = Schemata::Helpers.deep_copy(old_data)
          new_data.delete("foo2")
          new_data["foo4"] = "foo"
          new_data
        end

        define_generate_old_fields do |msg_obj|
          {}
        end

        define_mock_values({
          "foo1" => "foo",
          "foo3" => lambda { [Random.rand(11)] },
          "foo4" => Proc.new do
            time = Time.now
            time.to_s
          end
        })
      end

    end
  end
end
