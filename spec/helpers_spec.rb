require 'schemata/helpers/hash_copy'

describe Schemata::HashCopyHelpers do
  describe "#deep_copy" do
    it "should return a new string when given a string" do
      original = "foo"
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of String
      copy.should == original

      copy.object_id.should_not == original.object_id
    end

    it "should return a new hash when given a hash" do
      original = {"foo" => "bar"}
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Hash
      copy.should == original

      copy["hello"] = "goodbye"
      copy.keys.should_not =~ original.keys
    end

    it "should return a new array when given an array" do
      original = [1, 2, "hello"]
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Array
      copy.should == original

      original[0] = 0
      copy.should_not == original
    end

    it "should deep copy nested types" do
      original = {
        "foo" => "bar",
        "inner" => {
          "hello" => "goodbye"
        }
      }
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Hash
      copy.should == original

      original["inner"]["hello"] = "world"
      copy.keys.should =~ original.keys
      copy["inner"].keys.should =~ original["inner"].keys
      copy["inner"].values.should_not =~ original["inner"].values
    end
  end
end
