require 'schemata/component/foo'

describe Schemata::Component::Foo::V14 do
  describe "#new" do
    it "should define accessors for aux schema fields" do
      v14_obj = Schemata::Component::Foo::V14.new
      v14_obj.aux_data.respond_to?(:foo4).should be_true
      v14_obj.aux_data.respond_to?(:foo4=).should be_true
    end
  end

  describe "#generate_old_fields" do
    it "should emit correct fields if the object was constructed with aux_data" do
      v14_hash = {
        "foo1" => "hello",
        "foo3" => [3]
      }
      aux_data = { "foo4" => "foo" }
      v14_obj = Schemata::Component::Foo::V14.new(v14_hash, aux_data)
      downverted, old_fields = v14_obj.generate_old_fields

      old_fields.keys.should =~ ["foo4"]
      old_fields["foo4"].should == "foo"
    end

    it "should raise an error if the object was constructed without aux_data" do
      v14_hash = {
        "foo1" => "hello",
        "foo3" => [3]
      }
      v14_obj = Schemata::Component::Foo::V14.new(v14_hash)
      expect {
        v14_obj.generate_old_fields
      }.to raise_error(Schemata::DecodeError)
    end
  end
end
