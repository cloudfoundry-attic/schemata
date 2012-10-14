require 'rubygems'
require 'membrane'
require File.expand_path('../bar_v10', __FILE__)

class Bar
  class V11

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "bar1" => String,
        "bar2" => Integer,
        "bar4" => [Integer]
      }
    end

    def generate_old_fields
      first = @bar4.length > 0 ? @bar4[0] : 0
      {"bar3" => first}
    end

    def self.upvert(old_data)
      new_data = old_data.dup
      new_data["bar4"] = [old_data["bar3"]]
      new_data
    end

    # The developer should not need to touch anything
    # beneath this

    SCHEMA.schemas.keys.each do |k|
      attr_reader k.to_sym
    end


    def initialize(msg_data)
      SCHEMA.schemas.keys.each do |k|
        instance_variable_set "@#{k}", msg_data[k]
      end
    end

  end
end
