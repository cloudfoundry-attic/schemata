require 'membrane'
require 'schemata/common/msgbase'
require 'schemata/helpers/hash_copy'

module Schemata
  module CloudController
    module Bar
    end
  end
end

module Schemata::CloudController::Bar
  class V11
    include Schemata::MessageBase

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "bar1" => Integer,
        "bar3" => String
      }
    end

    AUX_SCHEMA = Membrane::SchemaParser.parse do
      {
        "bar2" => String
      }
    end

    MOCK_VALUES = {
      "bar1" => 1,
      "bar3" => "third"
    }

    MIN_VERSION_ALLOWED = 10

    def self.upvert(old_data)
      begin
        Schemata::CloudController::Bar::V10::SCHEMA.validate(old_data)
      rescue Membrane::Schemata::ValidationError => e
        raise Schemata::DecodeError.new(e.message)
      end

      new_data = Schemata::HashCopyHelpers.deep_copy(old_data)
      new_data["bar1"] = new_data["bar1"].length
      new_data.delete("bar2")
      new_data["bar3"] = "third"
      new_data
    end

    def generate_old_fields
      if aux_data.empty?
        raise Schemata::DecodeError.new("Necessary aux_data missing")
      end

      msg_contents = contents
      aux_contents = aux_data.contents
      diff = {}

      msg_contents["bar1"] = msg_contents["bar1"].to_s
      msg_contents["bar2"] = aux_contents["bar2"]
      msg_contents.delete("bar3")

      diff["bar1"] = msg_contents["bar1"]
      diff["bar2"] = msg_contents["bar2"]
      return Schemata::CloudController::Bar::V10.new(msg_contents), diff
    end
  end
end
