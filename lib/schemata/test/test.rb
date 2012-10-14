require 'yajl'
require File.expand_path('../bar', __FILE__)

module Schemata
  module Test

    # @param [String] A json message to validate
    #
    # @return [Bar::CURRENT] A validate Bar::CURRENT object
    # or nil if the json message doesn't validate
    #
    def self.validate_bar(bar_msg)
      bar_msg = Yajl::Parser.parse bar_msg

      # Determine which version
      version = get_version_number(Bar::CURRENT)
      message_version = get_highest_version(bar_msg)
      if version == message_version
        msg = bar_msg["V#{version}"]
        begin
          Bar::CURRENT::SCHEMA.validate msg
          Bar::CURRENT.new(msg)
        rescue Membrane::SchemaValidationError => e
          # Log error somewhere?
          p e
          nil
        end
      elsif version == message_version + 1
        # upvert
        msg = bar_msg["V#{message_version}"]
        begin
          Bar::PREVIOUS::SCHEMA.validate msg
          new_msg = Bar::CURRENT.upvert msg
          Bar::CURRENT::SCHEMA.validate new_msg
          Bar::CURRENT.new(new_msg)
        rescue Membrane::SchemaValidationError => e
          p e
          nil
        end
      elsif version == message_version - 1
        # Take the union
        msg = bar_msg["V#{message_version}"]
        old_fields = bar_msg["V#{version}"]
        new_msg = union(msg, old_fields)
        begin
          Bar::CURRENT::SCHEMA.validate new_msg
          Bar::CURRENT.new(new_msg)
        rescue Membrane::SchemaValidationError => e
          p e
          nil
        end
      else
        # Error
      end
    end

    # @param [Hash] A hash of data to convert to
    # a json string
    #
    # @raise [Membrane::SchemaValidationError] raised when
    # the data does not fit the schema for a Bar message
    #
    # @return [String] json representation of the message
    #
    def self.create_bar(bar_data)
      Bar::CURRENT::SCHEMA.validate bar_data
      bar_msg = Bar::CURRENT.new bar_data
      old_fields = bar_msg.generate_old_fields


      res = { 
        "V#{get_version_number(Bar::PREVIOUS)}" => old_fields,
        "V#{get_version_number(Bar::CURRENT)}" => bar_data
      }
      Yajl::Encoder.encode res
    end

    private

    def self.union(new_msg, old_fields)
      res = new_msg.dup
      old_fields.each do |k, v|
        res[k] = v
      end
      res
    end

    def self.get_version_number(class_name)
      class_name.to_s.split("::V")[-1].to_i
    end

    def self.get_highest_version(msg)
      msg.keys.map{|k| k=k[1..-1].to_i}.max
    end
  end
end
