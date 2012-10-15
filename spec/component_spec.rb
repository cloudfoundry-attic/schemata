require File.expand_path('../../lib/schemata/component/component', __FILE__)

describe "Schemata::Component" do

  before :each do
    @v10_msg = '{
      "min_version": 10,
      "V10": {
        "foo1": "hello",
        "foo2": 1
      }
    }'

    @v11_msg = '{
      "min_version": 10,
      "V11": {
        "foo1": "hello",
        "foo2": 1,
        "foo3": 1
      },
      "V10": {}
    }'

    @v12_msg = '{
      "min_version" : 10,
      "V12": {
        "foo1": "hello",
        "foo2": 1,
        "foo3": [1]
      },
      "V11": {
        "foo3": 1
      },
      "V10": {}
    }'

    @v13_msg = '{
      "min_version": 13,
      "V13": {
        "foo1": "hello",
        "foo3": [1],
        "foo4": "foo"
      }
    }'

    @v10_hash = {
      "foo1" => "hello",
      "foo2" => 1
    }

    @v11_hash = {
      "foo1" => "hello",
      "foo2" => 1,
      "foo3" => 1
    }

    @v12_hash = {
      "foo1" => "hello",
      "foo2" => 1,
      "foo3" => [1]
    }

    @v13_hash = {
      "foo1" => "hello",
      "foo3" => [1],
      "foo4" => "foo"
    }

  end

  describe "Foo::CURRENT = 10" do
    before :each do
      Schemata::Component::Foo.stub(:current_version).and_return(10)
      @curr_class = Schemata::Component::Foo.current_class
    end

    describe "#encode" do
      it "should take a v10 message and return a correct Foo::V10 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v10_msg)
        foo_obj.class.should == Schemata::Component::Foo::V10
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
      end

      it "should take a v11 message and return a correct Foo::V10 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v11_msg)
        foo_obj.class.should == Schemata::Component::Foo::V10
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
      end

      it "should take a v12 message and return a correct Foo::V10 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v12_msg)
        foo_obj.class.should == Schemata::Component::Foo::V10
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
      end

      it "should raise an error when a v10 message has an invalid V10 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {
            "foo1" => "foo",
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an error when a v11 message has an invalid union \
of V11 and V10 hashes" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {},
          "V11" => {
            "foo1" => "foo",
            "foo2" => "bar",
            "foo3" => 1
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an error when a v12 message has an invalid union \
of V10, V11, and V12 hashes" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {},
          "V11" => {"foo3" => 1},
          "V12" => {
            "foo1" => "foo",
            "foo2" => "bar",
            "foo3" => [1]
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)

        msg_hash["V11"]["foo2"] = "bar"
        msg_hash["V12"]["foo2"] = 1
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an IncompatibleVersionError when it gets a v13 msg" do
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            @v13_msg)
        }.to raise_error(Schemata::IncompatibleVersionError)
      end
    end

    describe "#encode" do
      it "should take a v10 obj and return the correct json string" do
        v10_obj = Schemata::Component::Foo::V10.new @v10_hash
        json = Schemata::Component.encode(v10_obj)
        returned_hash = Yajl::Parser.parse json
        returned_hash.keys.should =~ ['min_version', 'V10']

        returned_hash['min_version'].should ==
          @curr_class::MIN_VERSION_ALLOWED

        v10 = returned_hash['V10']
        v10.each do |k, v|
          v10[k].should == @v10_hash[k]
        end
      end
    end
  end

  describe "Foo::CURRENT = 11" do
    before :each do
      Schemata::Component::Foo.stub(:current_version).and_return(11)
      @curr_class = Schemata::Component::Foo.current_class
    end

    describe "#decode" do
      it "should take a v10 message, upvert, and return a correct V11 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v10_msg)
        foo_obj.class.should == Schemata::Component::Foo::V11
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == 1
      end

      it "should take a v11 message and return a correct V11 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v11_msg)
        foo_obj.class.should == Schemata::Component::Foo::V11
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == 1
      end

      it "should take a v12 message and return a correct V11 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v12_msg)
        foo_obj.class.should == Schemata::Component::Foo::V11
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == 1
      end

      it "should raise an error when a v10 message has an invalid V10 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {
            "foo1" => "foo",
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
           Schemata::Component::Foo,
           json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an error when a v11 message has an invalid V11 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {},
          "V11" => {
            "foo1" => "foo",
            "foo3" => 1
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

        it "should raise an error when a v12 message has an invalid union \
of V10, V11, and V12 hashes" do
          msg_hash = {
            "min_version" => 10,
            "V10" => {},
            "V11" => {"foo3" => [1]},
            "V12" => {
              "foo1" => "foo",
              "foo2" => 1,
              "foo3" => [1]
            }
          }
          json_msg = Yajl::Encoder.encode msg_hash
          expect {
            foo_obj = Schemata::Component.decode(
              Schemata::Component::Foo,
              json_msg)
          }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an IncompatibleVersionError on a v13 message" do
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            @v13_msg)
        }.to raise_error(Schemata::IncompatibleVersionError)
      end
    end

    describe "#encode" do
      it "should take a v11 obj and return the correct json string" do
        v11_obj = Schemata::Component::Foo::V11.new @v11_hash
        json = Schemata::Component.encode(v11_obj)
        returned_hash = Yajl::Parser.parse json

        returned_hash.keys.should =~ ['min_version', 'V10', 'V11']

        returned_hash['min_version'].should ==
          @curr_class::MIN_VERSION_ALLOWED

        v10 = returned_hash["V10"]
        v10.each do |k, v|
          v10[k].should == @v10_hash[k]
        end

        v11 = returned_hash["V11"]
        v11.each do |k, v|
          v11[k].should == @v11_hash[k]
        end
      end
    end
  end

  describe "Foo:CURRENT = 12" do
    before :each do
      Schemata::Component::Foo.stub(:current_version).and_return(12)
      @curr_class = Schemata::Component::Foo.current_class
    end

    describe "#decode" do
      it "should take a v10 message, upvert twice, and return a correct V12 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v10_msg)
        foo_obj.class.should == Schemata::Component::Foo::V12
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == [1]
      end

      it "should take a v11 message, upvert, and return a correct V12 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v11_msg)
        foo_obj.class.should == Schemata::Component::Foo::V12
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == [1]
      end

      it "should take a v12 message and return a correct V12 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v12_msg)
        foo_obj.class.should == Schemata::Component::Foo::V12
        foo_obj.foo1.should == "hello"
        foo_obj.foo2.should == 1
        foo_obj.foo3.should == [1]
      end

      it "should raise an error when a v10 message has an invalid V10 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {
            "foo1" => "foo"
          }
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an error when a v11 messsage an invalid V11 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {},
          "V11" => {}
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an error when a v12 message has an invalid V12 hash" do
        msg_hash = {
          "min_version" => 10,
          "V10" => {},
          "V11" => {"foo3" => 1},
          "V12" => {}
        }
        json_msg = Yajl::Encoder.encode msg_hash
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            json_msg)
        }.to raise_error(Schemata::DecodeError)
      end

      it "should raise an IncompatibleVersionError on a v13 message" do
        expect {
          foo_obj = Schemata::Component.decode(
            Schemata::Component::Foo,
            @v13_msg)
        }.to raise_error(Schemata::IncompatibleVersionError)
      end
    end

    describe "#encode" do
      it "should take a v12 obj and return the correct json string" do
        v12_obj = Schemata::Component::Foo::V12.new @v12_hash
        json = Schemata::Component.encode(v12_obj)
        returned_hash = Yajl::Parser.parse json

        returned_hash.keys.should =~ ['min_version', 'V10', 'V11', 'V12']

        returned_hash['min_version'].should ==
          @curr_class::MIN_VERSION_ALLOWED

        v10 = returned_hash['V10']
        v10.each do |k, v|
          v10[k].should == @v10_hash[k]
        end

        v11 = returned_hash['V11']
        v11.each do |k, v|
          v11[k].should == @v11_hash[k]
        end

        v12 = returned_hash['V12']
        v12.each do |k, v|
          v12[k].should == @v12_hash[k]
        end
      end
    end
  end

  describe "Foo:CURRENT = 13" do
    before :each do
      Schemata::Component::Foo.stub(:current_version).and_return(13)
      @curr_class = Schemata::Component::Foo.current_class
    end

    describe "#decode" do
      it "should validate a v10 message and return a correct V13 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v10_msg)
        foo_obj.class.should == Schemata::Component::Foo::V13
        foo_obj.foo1.should == "hello"
        foo_obj.foo3.should == [1]
        foo_obj.foo4.should == "foo"
      end

      it "should validate a v11 message and return a correct V13 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v11_msg)
        foo_obj.class.should == Schemata::Component::Foo::V13
        foo_obj.foo1.should == "hello"
        foo_obj.foo3.should == [1]
        foo_obj.foo4.should == "foo"
      end

      it "should validate a v12 message and return a correct V13 object" do
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          @v12_msg)
        foo_obj.class.should == Schemata::Component::Foo::V13
        foo_obj.foo1.should == "hello"
        foo_obj.foo3.should == [1]
        foo_obj.foo4.should == "foo"
      end

      it "should validate a v13 message and return a correct V13 object" do
        foo_obj =Schemata::Component.decode(
          Schemata::Component::Foo,
          @v13_msg)
        foo_obj.class.should == Schemata::Component::Foo::V13
        foo_obj.foo1.should == "hello"
        foo_obj.foo3.should == [1]
        foo_obj.foo4.should == "foo"
      end
    end

    describe "#encode" do
      it "should take a v13 obj and return the correct json string" do
        v13_obj = Schemata::Component::Foo::V13.new @v13_hash
        json = Schemata::Component.encode(v13_obj)
        returned_hash = Yajl::Parser.parse json

        returned_hash.keys.should =~ ['min_version', 'V13']

        returned_hash['min_version'].should ==
          @curr_class::MIN_VERSION_ALLOWED

        v13 = returned_hash['V13']
        v13.each do |k, v|
          v13[k].should == @v13_hash[k]
        end
      end
    end
  end

  describe "Other tests" do
    it "should raise an error if the 'min_version' is missing" do
      msg_hash = {
        "V10" => {},
        "V11" => {
          "foo1" => "foo",
          "foo2" => 1,
          "foo3" => 1
        }
      }
      json_msg = Yajl::Encoder.encode msg_hash
      expect {
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          json_msg)
      }.to raise_error(Schemata::DecodeError)
    end

    it "should raise an error if the message has no Vxx key" do
      msg_hash = {
        "min_version" => 10
      }
      json_msg = Yajl::Encoder.encode msg_hash
      expect {
        foo_obj = Schemata::Component.decode(
          Schemata::Component::Foo,
          json_msg)
      }.to raise_error(Schemata::DecodeError)
    end
  end
end

describe "Schemata::Component::Foo" do
  describe "V10" do
    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 10
      foo_obj.foo1 = "new name"
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 10
      expect {
        foo_obj.foo1 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V11" do
    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 11
      foo_obj.foo2 = 10
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 11
      expect {
        foo_obj.foo2 = "foo"
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V12" do
    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 12
      foo_obj.foo3 = [1, 2]
    end

    it "should raise an error if an attribute is incorrectly assigned" do
      foo_obj = Schemata::Component.mock_foo 12
      expect {
        foo_obj.foo3 = 1
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "V13" do
    it "should not raise an error if an attribute is correctly assigned" do
      foo_obj = Schemata::Component.mock_foo 13
      foo_obj.foo4 = "foobar"
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
  end
end
