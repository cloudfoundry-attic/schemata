module Schemata
  module HealthManager
    module StatusFlappingResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            'indices' => [{
              'index'       => Integer,
              'since'       => enum(Integer, Float, NilClass),
            }]
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
            "indices" => proc do
            [{
              "index"       => 0,
              "since"       => Time.now.to_i,
            }]
            end
          }
        end
      end
    end
  end
end
