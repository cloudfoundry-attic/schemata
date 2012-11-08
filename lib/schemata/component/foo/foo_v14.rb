require 'membrane'
require 'schemata/common/msgtypebase'
require 'schemata/helpers/hash_copy'

module Schemata
  module Component
    module Foo
      extend Schemata::MessageTypeBase

      version 14 do
        define_schema do
          {
            "foo1" => String,
            "foo3" => [Integer]
          }
        end

        define_aux_schema do
          {"foo4" => String}
        end

        define_min_version 13

        define_upvert do |old_data|
          new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
          new_data.delete("foo4")
          new_data
        end

        define_generate_old_fields do |msg_obj|
          msg_contents = msg_obj.contents
          aux_contents = msg_obj.aux_data.contents
          msg_contents.update(aux_contents)
          aux_contents
        end
      end

    end
  end
end
