require File.expand_path('../../lib/schemata/test/test', __FILE__)

describe "Schemata::Test" do

  describe "Bar::CURRENT = V10" do
    before :all do
      Bar::CURRENT = Bar::V10

      @v10 = "{
        \"V9\":{},
        \"V10\":{
          \"bar1\":\"foo\",
          \"bar2\":1,
          \"bar3\":1
        }
      }"

      @v11 = "{
        \"V10\": {\"bar3\": 1},
        \"V11\": {
          \"bar1\": \"foo\",
          \"bar2\": 1,
          \"bar4\": [1]
        }
      }"
    end

    it "should validate a v10 message" do
      msg = Schemata::Test.validate_bar @v10
      msg.should_not be_nil
    end

    it "should return an Bar object with the correct info" do
      msg = Schemata::Test.validate_bar @v10
      msg.bar1.should == "foo"
      msg.bar2.should == 1
      msg.bar3.should == 1
    end

    it "should vlaidate a v11 message" do
      msg = Schemata::Test.validate_bar @v11
      msg.should_not be_nil
    end

    it "should return a Bar::V10 object when it receives a v11 message" do
      msg = Schemata::Test.validate_bar @v11
      msg.class.should == Bar::V10
    end

    it "should return a Bar::V10 object with the correct info" do
      msg = Schemata::Test.validate_bar @v11
      msg.bar1.should == "foo"
      msg.bar2.should == 1
      msg.bar3.should == 1
    end
  end

  describe "Bar::CURRENT = V11" do
    before :all do
      Bar::CURRENT = Bar::V11
      Bar::PREVIOUS = Bar::V10

      @v10 = "{
        \"V9\":{},
        \"V10\":{
          \"bar1\":\"foo\",
          \"bar2\":1,
          \"bar3\":1
        }
      }"

      @v11 = "{
        \"V10\": {\"bar3\": 1},
        \"V11\": {
          \"bar1\": \"foo\",
          \"bar2\": 1,
          \"bar4\": [1]
        }
      }"
    end

    it "should validate a v10 message" do
      msg = Schemata::Test.validate_bar @v10
      msg.should_not be_nil
    end

    it "should return a Bar::V11 object when given a v10 message" do
      msg = Schemata::Test.validate_bar @v10
      msg.class.should == Bar::V11
    end

    it "should validate a v11 message" do
      msg = Schemata::Test.validate_bar @v11
      msg.should_not be_nil
    end
  end
end
