require File.expand_path('../../lib/schemata/helpers/hash_copy', __FILE__)

describe Schemata::HashCopyHelpers do
  describe "#deep_copy" do
    it "should return a new string when given a string" do
      original = "foo"
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original

      original << "bar"
      copy.should_not == original
    end

    it "should return a new Fixnum when given a Fixnum" do
      original = 10
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original

      original += 20
      copy.should_not == original
    end

    it "should return a new float when given a float" do
      original = 3.14159
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original

      original *= 2.718
      copy.should_not == original
    end

    it "should return a new hash when given a hash" do
      original = {"foo" => "bar"}
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.keys.should =~ original.keys
      copy.values.should =~ original.values

      copy["hello"] = "goodbye"
      copy.keys.should_not =~ original.keys
    end

    it "should return a new array when given an array" do
      original = [1, 2, "hello"]
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.should == original

      original[0] = 0
      copy.should_not == original
    end

    it "should return a new hash given a nested hash" do
      original = {
        "foo" => "bar",
        "inner" => {
          "hello" => "goodbye"
        }
      }
      copy = Schemata::HashCopyHelpers.deep_copy(original)
      copy.keys.should =~ original.keys
      copy.values.should =~ original.values

      original["inner"]["hello"] = "world"
      copy.keys.should =~ original.keys
      copy["inner"].keys.should =~ original["inner"].keys
      copy["inner"].values.should_not =~ original["inner"].values
    end
  end
end
