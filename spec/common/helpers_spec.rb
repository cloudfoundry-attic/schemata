require 'schemata/helpers/hash_copy'

describe Schemata::HashCopyHelpers do
  describe "#deep_copy" do
    it "should deep copy nil" do
      copy = Schemata::HashCopyHelpers.deep_copy(nil)
      copy.should == nil
    end

    it "should deep copy a given string" do
      original = "foo"
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of String
      copy.should == original
      copy.object_id.should_not == original.object_id
    end

    it "should deep copy a given boolean" do
      Schemata::HashCopyHelpers.deep_copy(true).
        should be_an_instance_of TrueClass
      Schemata::HashCopyHelpers.deep_copy(false).
        should be_an_instance_of FalseClass
    end

    it "should deep copy a given numeric type" do
      original = 0
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original
      copy.should be_an_instance_of Fixnum

      # set original to be max fixnum + 1
      original = 2**(0.size * 8 -2)
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original
      copy.should be_an_instance_of Bignum

      original = 0.0
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original
      copy.should be_an_instance_of Float
    end

    it "should deep copy a given hash" do
      original = {"foo" => "bar"}
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should be_instance_of Hash
      copy.should == original

      copy.object_id.should_not == original.object_id
      copy["foo"].object_id.should_not == original["foo"].object_id
    end

    it "should deep copy a given array" do
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

    it "should raise error for unknown type" do
      klass = Class.new
      expect do
        Schemata::HashCopyHelpers.deep_copy(klass.new)
      end.to raise_error(described_class::CopyError, /Unexpected class: /)
    end
  end
end
