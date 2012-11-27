require 'schemata/component/foo'
require 'schemata/common/error'
require 'support/helpers'

describe Schemata::Component::Foo do
  describe "V10" do
    it "should define accessors for the schema" do
      v10_obj = Schemata::Component::Foo::V10.new
      v10_obj.respond_to?(:foo1).should be_true
      v10_obj.respond_to?(:foo1=).should be_true
      v10_obj.respond_to?(:foo2).should be_true
      v10_obj.respond_to?(:foo2=).should be_true
    end

    it "should not raise an error if an incomplete but valid hash is given" do
      v10_hash = {"foo1" => "foo"}
      expect { Schemata::Component::Foo::V10.new(v10_hash) }.to_not raise_error
    end

    it "should raise an error if an incomplete and invalid hash is given" do
      v10_hash = {"foo1" => 1}
      expect {
        Schemata::Component::Foo::V10.new(v10_hash)
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 10
      expect { foo_obj.foo1 = "new name" }.to_not raise_error
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 10
      expect { foo_obj.foo1 = 1 }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an incomplete msg_obj is updated \
correctly" do
      v10_hash = {"foo1" => "foo"}
      v10_obj = Schemata::Component::Foo::V10.new(v10_hash)
      expect { v10_obj.foo1 = "new name" }.to_not raise_error
    end

    it "should raise an error if an incomplete msg_obj is updated \
incorrectly" do
      v10_hash = {"foo1" => "foo"}
      v10_obj = Schemata::Component::Foo::V10.new(v10_hash)
      expect { v10_obj.foo1 = 1 }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V11" do
    it "should define accessors for the schema" do
      v11_obj = Schemata::Component::Foo::V11.new
      v11_obj.respond_to?(:foo1).should be_true
      v11_obj.respond_to?(:foo1=).should be_true
      v11_obj.respond_to?(:foo2).should be_true
      v11_obj.respond_to?(:foo2=).should be_true
      v11_obj.respond_to?(:foo3).should be_true
      v11_obj.respond_to?(:foo3=).should be_true
    end

    it "should not raise an error if an incomplete but valid hash is given" do
      v11_hash = {"foo1" => "foo"}
      expect { Schemata::Component::Foo::V11.new(v11_hash) }.to_not raise_error
    end

    it "should raise an error if an incomplete and invalid hash is given" do
      v11_hash = {"foo1" => 1}
      expect {
        v11_obj = Schemata::Component::Foo::V11.new(v11_hash)
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 11
      expect { foo_obj.foo2 = 10 }.to_not raise_error
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 11
      expect {
        foo_obj.foo2 = "foo"
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an incomplete msg_obj is updated \
correctly" do
      v11_hash = {"foo1" => "foo"}
      v11_obj = Schemata::Component::Foo::V11.new(v11_hash)
      expect { v11_obj.foo1 = "new name" }.to_not raise_error
    end

    it "should raise an error if an incomplete msg_obj is updated \
incorrectly" do
      v11_hash = {"foo1" => "foo"}
      v11_obj = Schemata::Component::Foo::V11.new(v11_hash)
      expect {
        v11_obj.foo1 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V12" do
    it "should define accessors for the schema" do
      v12_obj = Schemata::Component::Foo::V12.new
      v12_obj.respond_to?(:foo1).should be_true
      v12_obj.respond_to?(:foo1=).should be_true
      v12_obj.respond_to?(:foo2).should be_true
      v12_obj.respond_to?(:foo2=).should be_true
      v12_obj.respond_to?(:foo3).should be_true
      v12_obj.respond_to?(:foo3=).should be_true
    end

    it "should not raise an error if an incomplete but valid hash is given" do
      v12_hash = {"foo1" => "foo"}
      expect { Schemata::Component::Foo::V12.new(v12_hash) }.to_not raise_error
    end

    it "should raise an error if an incomplete and invalid hash is given" do
      v12_hash = {"foo1" => 1}
      expect {
        Schemata::Component::Foo::V12.new(v12_hash)
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 12
      expect { foo_obj.foo3 = [1, 2] }.to_not raise_error
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 12
      expect {
        foo_obj.foo3 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an incomplete msg_obj is updated \
correctly" do
      v12_hash = {"foo1" => "foo"}
      v12_obj = Schemata::Component::Foo::V12.new(v12_hash)
      expect { v12_obj.foo1 = "new name" }.to_not raise_error
    end

    it "should raise an error if an incomplete msg_obj is updated \
incorrectly" do
      v12_hash = {"foo1" => "foo"}
      v12_obj = Schemata::Component::Foo::V12.new(v12_hash)
      expect {
        v12_obj.foo1 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V13" do
    it "should define accessors for the schema" do
      v13_obj = Schemata::Component::Foo::V13.new
      v13_obj.respond_to?(:foo1).should be_true
      v13_obj.respond_to?(:foo1=).should be_true
      v13_obj.respond_to?(:foo3).should be_true
      v13_obj.respond_to?(:foo3=).should be_true
      v13_obj.respond_to?(:foo4).should be_true
      v13_obj.respond_to?(:foo4=).should be_true
    end

    it "should not raise an error if an incomplete but valid hash is given" do
      v13_hash = {"foo1" => "foo"}
      expect { Schemata::Component::Foo::V13.new(v13_hash) }.to_not raise_error
    end

    it "should raise an error if an incomplete and invalid hash is given" do
      v13_hash = {"foo1" => 1}
      expect {
        Schemata::Component::Foo::V13.new(v13_hash)
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 13
      expect { foo_obj.foo4 = "foobar" }.to_not raise_error
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 13
      expect {
        foo_obj.foo4 =1
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should raise an error if an accessed field was removed" do
      foo_obj = Schemata::Component.mock_foo 13
      expect {
        foo_obj.foo2
      }.to raise_error
    end

    it "should not raise an error if an incomplete msg_obj is updated \
correctly" do
      v13_hash = {"foo1" => "foo"}
      v13_obj = Schemata::Component::Foo::V13.new(v13_hash)
      expect { v13_obj.foo1 = "new name" }.to_not raise_error
    end

    it "should raise an error if an incomplete msg_obj is updated \
incorrectly" do
      v13_hash = {"foo1" => "foo"}
      v13_obj = Schemata::Component::Foo::V13.new(v13_hash)
      expect {
        v13_obj.foo1 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end
end
