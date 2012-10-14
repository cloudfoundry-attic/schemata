require 'rubygems'
require 'membrane'

class Bar
  class V10

    SCHEMA = Membrane::SchemaParser.parse do
      {
        "bar1" => String,
        "bar2" => Integer,
        "bar3" => Integer
      }
    end

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
