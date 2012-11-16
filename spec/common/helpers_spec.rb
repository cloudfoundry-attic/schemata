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

      copy.object_id.should_not == original.object_id
      copy["foo"].object_id.should_not == original["foo"].object_id
    end

    it "should return a new array when given an array" do
      original = [1, 2, "hello"]
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Array
      copy.should == original

      copy.object_id.should_not == original.object_id
      # only check object_id of String object
      copy[2].object_id.should_not == original[2].object_id
    end

    it "should deep copy nested types" do
      original = {
        "foo" => "bar",
        "inner" => {
          "hello" => "goodbye",
        },
      }
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Hash
      copy.should == original

      copy.object_id.should_not == original.object_id
      copy["foo"].object_id.should_not == original["foo"].object_id
      copy["inner"].object_id.should_not == original["inner"].object_id
      copy["inner"]["hello"].object_id.
        should_not == original["inner"]["hello"].object_id
    end
  end
end
