module Schemata
  module CloudController
    module BulkCredentialsResponse
      version 1 do
        include_preschemata

        define_schema do
          {
            "user"      => String,
            "password"  => String,
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
            "user"      => "sre@vmware.com",
            "password"  => "the_admin_pw"
          }
        end
      end
    end
  end
end
