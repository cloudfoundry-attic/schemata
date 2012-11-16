require 'yajl'
require 'support/helpers'
require 'schemata/staging/staging'

describe Schemata::Staging do
  describe ".mock_message" do
    it "should return a V1 object" do
      msg_obj = Schemata::Staging.mock_message(1)
      msg_obj.class.should == Schemata::Staging::Message::V1
    end
  end
end

describe Schemata::Staging::Message do
  describe ".decode" do
    context "current version is 1" do

      before :each do
        set_current_version(Schemata::Staging::Message, 1)
      end

      after :each do
        reset_version(Schemata::Staging::Message)
      end

      it "should return a V1 object when given a flat hash" do
        json = Yajl::Encoder.encode(
          Schemata::Staging::Message::V1::MOCK_VALUES)
        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V1

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V1::MOCK_VALUES["properties"]
      end

      it "should return a V1 object when given a V1-encoded json" do
        v1_hash = Schemata::HashCopyHelpers.deep_copy(
          Schemata::Staging::Message::V1::MOCK_VALUES)
        msg_hash = {"V1" => v1_hash, "min_version" => 1}

        json = Yajl::Encoder.encode(msg_hash)

        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V1

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V1::MOCK_VALUES["properties"]
      end

      it "should return a V1 object when given a mixed (flat hash + V1-encoded) json" do
        msg_hash = Schemata::HashCopyHelpers.deep_copy(
          Schemata::Staging::Message::V1::MOCK_VALUES)

        v1_hash = Schemata::HashCopyHelpers.deep_copy(msg_hash)
        msg_hash["V1"] = v1_hash

        msg_hash["min_version"] = 1

        json = Yajl::Encoder.encode(msg_hash)

        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V1

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V1::MOCK_VALUES["properties"]
      end

      it "should return a V1 object when given a V2-encoded json message" do
        v2_hash = Schemata::HashCopyHelpers.deep_copy(
          Schemata::Staging::Message::V1::MOCK_VALUES
        )
        msg_hash = {
          "V2" => v2_hash, "V1" => {}, "min_version" => 1
        }

        json = Yajl::Encoder.encode(msg_hash)

        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V1

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V1::MOCK_VALUES["properties"]
      end

      it "should raise an error if the input does not have the valid Schemata structure or a complete flat hash of the data" do
        json = Yajl::Encoder.encode({"app_id" => 1})
        expect {
          msg_obj = Schemata::Staging::Message.decode(json)
        }.to raise_error(Schemata::DecodeError)
      end
    end

    context "current version is 2" do
      it "should return a V2 object given a V1-encoded json" do
        v1_hash = Schemata::HashCopyHelpers.deep_copy(
          Schemata::Staging::Message::V1::MOCK_VALUES
        )
        msg_hash = {"V1" => v1_hash, "min_version" => 1}

        json = Yajl::Encoder.encode(msg_hash)

        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V2

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V2::MOCK_VALUES["properties"]
      end

      it "should return a V2 object given a V2-encoded json" do
        v2_hash = Schemata::HashCopyHelpers.deep_copy(
          Schemata::Staging::Message::V2::MOCK_VALUES
        )
        msg_hash = {"V2" => v2_hash, "V1" => {}, "min_version" => 1}

        json = Yajl::Encoder.encode(msg_hash)

        msg_obj = Schemata::Staging::Message.decode(json)
        msg_obj.class.should == Schemata::Staging::Message::V2

        msg_obj.app_id.should == 1
        msg_obj.download_uri.should == "http://foobar@172.0.0.0:100/download"
        msg_obj.upload_uri.should == "http://foobar@172.0.0.0:100/upload"
        msg_obj.properties.should ==
          Schemata::Staging::Message::V2::MOCK_VALUES["properties"]
      end

      it "should raise an error if the json has additional fields" do
        json = '{"V2":{}, "min_version":1, "foo":"bar"}'
        expect {
          msg_obj = Schemata::Staging::Message.decode(json)
        }.to raise_error(Schemata::DecodeError)
      end
    end
  end
end

describe Schemata::Staging::Message::V1 do
  before :each do
    set_current_version(Schemata::Staging::Message, 1)
  end

  after :each do
    reset_version(Schemata::Staging::Message)
  end

  describe "#new" do
    it "should create a V1 obj with an incomplete hash" do
      msg_obj = Schemata::Staging::Message::V1.new({"app_id" => 1})
    end

    it "should raise an error if the hash contains incorrect types" do
      expect {
        msg_obj = Schemata::Staging::Message::V1.new({"app_id" => "foo"})
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "#encode" do
    it "should return a json string, with V1 hash also in the raw payload" do
      msg_obj = Schemata::Staging.mock_message(1)
      json = msg_obj.encode
      json_hash = Yajl::Parser.parse(json)

      json_hash.should have_key "V1"
      json_hash.should have_key "min_version"

      v1_hash = json_hash['V1']
      min_version = json_hash['min_version']
      json_hash.delete('V1')
      json_hash.delete('min_version')

      v1_hash.should == json_hash
    end

    it "should raise an error if the object is not complete" do
      msg_obj = Schemata::Staging::Message::V1.new({"app_id" => 1})
      expect {
        json = msg_obj.encode
      }.to raise_error(Schemata::EncodeError)
    end
  end

  describe "#app_id" do
    it "should return the app_id if it was specified at instantiation" do
      msg_obj = Schemata::Staging::Message::V1.new({"app_id" => 1})
      msg_obj.app_id.should == 1
    end

    it "should return the app_id if it was set with an attr wrtier" do 
      msg_obj = Schemata::Staging::Message::V1.new({})
      msg_obj.app_id = 1
      msg_obj.app_id.should == 1
    end

    it "should return nil if the app_id was never set" do
      msg_obj = Schemata::Staging::Message::V1.new({})
      msg_obj.app_id.should be_nil
    end
  end

  describe "#app_id=" do
    it "should change the app_id and return the new value" do
      msg_obj = Schemata::Staging::Message::V1.new({"app_id" => 1})
      ret = (msg_obj.app_id = 2)
      msg_obj.app_id.should == 2
      ret.should == 2
    end

    it "should raise an error if the wrong type is written" do
      msg_obj = Schemata::Staging::Message::V1.new({})
      expect {
        msg_obj.app_id = "foo"
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end
end

describe Schemata::Staging::Message::V2 do
  before :each do
    set_current_version(Schemata::Staging::Message, 2)
  end

  after :each do
    reset_version(Schemata::Staging::Message)
  end

  describe "#new" do
    it "should create a V2 object given an incomplete hash" do
      msg_obj = Schemata::Staging::Message::V2.new({"app_id" => 1})
    end

    it "should raise an error if the hash contains incorrect types" do
      expect {
        msg_obj = Schemata::Staging::Message::V2.new({"app_id" => "foo"})
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end

  describe "#encode" do
    it "should return a json string with the proper Schemata format" do
      msg_obj = Schemata::Staging.mock_message(2)
      json = msg_obj.encode
      json_hash = Yajl::Parser.parse(json)

      v2_hash = json_hash['V2']
      v1_hash = json_hash['V1']
      min_version = json_hash['min_version']

      v2_hash.should == Schemata::Staging::Message::V2::MOCK_VALUES
      v1_hash.should == {}
      min_version.should == 1
    end

    it "should raise an error if the object is incomplete" do
      msg_obj = Schemata::Staging::Message::V2.new({})
      expect {
        msg_obj.encode
      }.to raise_error(Schemata::EncodeError)
    end
  end

  describe "#app_id" do
    it "should return the app_id if it was specified at instatiation" do
      msg_obj = Schemata::Staging::Message::V2.new({"app_id" => 1})
      msg_obj.app_id.should == 1
    end

    it "should return the app_id if it was set with an attr writer" do
      msg_obj = Schemata::Staging::Message::V2.new({})
      msg_obj.app_id = 1
      msg_obj.app_id.should == 1
    end

    it "should return nil if the app_id was never specified" do
      msg_obj = Schemata::Staging::Message::V2.new({})
      msg_obj.app_id.should be_nil
    end
  end

  describe "#app_id=" do
    it "should change the app_id and return the new value" do
      msg_obj = Schemata::Staging::Message::V2.new({"app_id" => 1})
      ret = (msg_obj.app_id =2)
      msg_obj.app_id.should == 2
      ret.should == 2
    end

    it "should raise an error if the wrong type is given" do
      msg_obj = Schemata::Staging::Message::V2.new({"app_id" => 1})
      expect {
        msg_obj.app_id = "foo"
      }.to raise_error(Schemata::UpdateAttributeError)
    end
  end
end
