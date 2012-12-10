module Schemata
  module Router
    module RegisterRequest
      version 1 do
        include_preschemata

        define_schema do
          {
            optional("dea")                   => String,
            optional("app")                   => String,
            "uris"                            => [String],
            "host"                            => String,
            "port"                            => Integer,
            "tags"  => {
              optional("framework")           => String,
              optional("runtime")             => String,
              optional("component")           => String,
            },
            optional("private_instance_id")  => String,
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
            "dea"   => proc { VCAP.secure_uuid },
            "app"   => proc { Random.rand(100).to_s },
            "uris"  => ["foo.vcap.me"],
            "host"  => "127.0.0.1",
            "port"  => 80,
            "tags"  => {
              "framework" => "rails3",
              "runtime"   => "ruby18",
              "component" => "dashboard",
            },
            "private_instance_id" => proc { VCAP.secure_uuid },
          }
        end
      end
    end
  end
end
