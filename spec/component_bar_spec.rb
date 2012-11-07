require 'schemata/component/component'
require File.expand_path('../support/helpers', __FILE__)

describe Schemata::Component do
  before :each do
    @v10_msg = '{
      "min_version": 10,
      "V10": {
        "bar1": "first",
        "bar2": "second"
      }
    }'

    @v11_msg = '{
      "min_version": 10,
      "V11": {
        "bar1": 1,
        "bar3": "third"
      },
      "V10": {
        "bar1": "1",
        "bar2": "second"
      }
    }'

    @v10_hash = {
      "bar1" => "1",
      "bar2" => "second"
    }

    @v11_hash = {
      "bar1" => 1,
      "bar3" => "third"
    }
  end

  describe "#decode" do
    describe "(current version is 10)" do
      before :each do
        set_current_version(Schemata::Component::Bar, 10)
      end

      after :each do
        reset_version(Schemata::Component::Bar)
      end

      it "should take a v10 msg and create a v10 obj" do
        msg_obj = Schemata::Component.decode(Schemata::Component::Bar,
                                             @v10_msg)
        msg_obj.bar1.should == "first"
        msg_obj.bar2.should == "second"
      end

      it "should take a v11 msg and create a v10 obj" do
        msg_obj = Schemata::Component.decode(Schemata::Component::Bar,
                                             @v11_msg)
        msg_obj.bar1.should == "1"
        msg_obj.bar2.should == "second"
      end
    end

    describe "(current version is 11)" do
      before :each do
        set_current_version(Schemata::Component::Bar, 11)
      end

      after :each do
        reset_version(Schemata::Component::Bar)
      end

      it "should take a v10 msg and create a v11 obj" do
        msg_obj = Schemata::Component.decode(Schemata::Component::Bar,
                                             @v10_msg)
        msg_obj.bar1.should == 5
        msg_obj.bar3.should == "third"
      end

      it "should take a v11 msg and create a v11 obj" do
        msg_obj = Schemata::Component.decode(Schemata::Component::Bar,
                                             @v11_msg)
        msg_obj.bar1.should == 1
        msg_obj.bar3.should == "third"
      end
    end
  end

  describe "#encode" do
    describe "(current version is 10)" do
      before :each do
        set_current_version(Schemata::Component::Bar, 10)
      end

      after :each do
        reset_version(Schemata::Component::Bar)
      end

      it "should take a v10 obj and encode a json msg" do
        v10_obj = Schemata::Component::Bar::V10.new(@v10_hash)
        json_msg = Schemata::Component.encode(v10_obj)
        returned_hash = Yajl::Parser.parse(json_msg)

        returned_hash.keys.should =~ ['min_version', 'V10']
        returned_hash['min_version'].should ==
          @curr_class::MIN_VERSION_ALLOWED

        v10 = returned_hash['V10']
        v10.each do |k, v|
          v10[k].should == @v10_hash[k]
        end
      end
    end

    describe "(current version is 11)" do
      before :each do
        set_current_version(Schemata::Component::Bar, 11)
      end

      it "should take a v11 obj and encode a json msg" do
        aux_data = {"bar2" => "second" }
        v11_obj = Schemata::Component::Bar::V11.new(@v11_hash, aux_data)
        json_msg = Schemata::Component.encode(v11_obj)
        returned_hash = Yajl::Parser.parse(json_msg)

        returned_hash.keys.should =~ ['min_version', 'V10', 'V11']
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
      end

      after :each do
        reset_version(Schemata::Component::Bar)
      end
    end
  end
end
