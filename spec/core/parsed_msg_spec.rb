require "spec_helper"

describe Schemata::ParsedMessage do
  describe "#new" do
    it "should raise an error if 'min_version' is missing" do
      json = '{
        "V10" : { "foo" : "bar" }
      }'
      expect {
        Schemata::ParsedMessage.new(json)
      }.to raise_error(Schemata::DecodeError)
    end

    it "should raise an error if there are non-Vxx hashes" do
      json = '{
        "min_version" : 10,
        "foo" : "bar"
      }'
      expect {
        Schemata::ParsedMessage.new(json)
      }.to raise_error(Schemata::DecodeError)
    end

    it "should raise an error if there are no Vxx hashes" do
      json = '{
        "min_version" : 10
      }'
      expect {
        Schemata::ParsedMessage.new(json)
      }.to raise_error(Schemata::DecodeError)
    end

    it "should return a new Schemata::ParsedMessage if the hash is valid" do
      json = '{
        "min_version" : 10,
        "V10" : { "foo" : "bar" },
        "V11" : { "foo" : "bar"}
      }'
      msg = Schemata::ParsedMessage.new(json)
      msg.min_version.should == 10
      msg.version.should == 11
      msg.contents["V10"]["foo"].should == "bar"
      msg.contents["V11"]["foo"].should == "bar"
    end
  end
end
