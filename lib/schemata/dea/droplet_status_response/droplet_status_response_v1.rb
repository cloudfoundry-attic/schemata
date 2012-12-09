require 'membrane'
require 'schemata/helpers/hash_copy'
require 'schemata/common/msgtypebase'
require 'vcap/common'

module Schemata
  module DEA
    module DropletStatusResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "name" => String,
            "uris" => [String],
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
            "name" => "foo",
            "uris" => ['foo.com', 'bar.com'],
          }
        end
      end
    end
  end
end
