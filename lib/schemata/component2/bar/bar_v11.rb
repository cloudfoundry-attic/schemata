require 'membrane'
require 'schemata/common/msgtypebase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component2
    module Bar

      version 11 do
        define_schema do
          {
            "bar1" => Integer,
            "bar3" => String
          }
        end

        define_aux_schema do
          {
            "bar2" => String
          }
        end

        define_min_version 10

        define_upvert do |old_data|
          new_data = Schemata::Helpers.deep_copy(old_data)
          new_data["bar1"] = new_data["bar1"].length
          new_data.delete("bar2")
          new_data["bar3"] = "third"
          new_data
        end

        define_generate_old_fields do |msg_obj|
          msg_contents = msg_obj.contents
          aux_contents = msg_obj.aux_data.contents
          diff = {}

          msg_contents["bar1"] = msg_contents["bar1"].to_s
          msg_contents["bar2"] = aux_contents["bar2"]
          msg_contents.delete("bar3")

          diff["bar1"] = msg_contents["bar1"]
          diff["bar2"] = msg_contents["bar2"]
          diff
        end

        define_constant :MOCK_VALUES, {
          "bar1" => 1,
          "bar3" => "third",
        }
      end
    end
  end
end
