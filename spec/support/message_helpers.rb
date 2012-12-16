shared_examples "a message" do

  version = described_class.version

  let(:component_name)    { described_class.name.split("::")[1] }
  let(:message_type_name) { described_class.name.split("::")[2] }
  let(:message_name)      { described_class.name.split("::")[3] }

  let(:component)         { Schemata::const_get(component_name) }
  let(:message_type)      { component::const_get(message_type_name) }
  let(:message)           { described_class }

  let(:mock_method)       { "mock_#{decamelize(message_type_name)}" }

  before :each do
    set_current_version(message_type, version)
  end

  after :each do
    reset_version(message_type)
  end

  describe "#new" do
    it "should create a #{described_class} object with an incomplete hash" do
      mock_hash = component.send(mock_method, 1).contents
      first_key = mock_hash.keys[0]
      first_value = mock_hash[first_key]

      msg_obj = message.new({first_key => first_value})
      msg_obj.class.should == message
      msg_obj.send(first_key).should == first_value
    end

    it "should raise an error if the hash contains incorrect types" do
      mock_hash = component.send(mock_method, 1).contents
      first_key = mock_hash.keys[0]
      first_value = mock_hash[first_key]

      schema = message.schema.schemas[first_key]
      unallowed_classes = get_unallowed_classes(schema)
      bad_value = default_value(unallowed_classes.to_a[0])

      expect {
        msg_obj = message.new({first_key => bad_value})
      }.to raise_error(Schemata::UpdateAttributeError)
    end

    it "should stringify keys when they are symbols" do
      mock_hash = component.send(mock_method, 1).contents
      first_key = mock_hash.keys[0]
      first_value = mock_hash[first_key]

      input_hash = {
        first_key.to_sym => first_value
      }
      msg_obj = message.new(input_hash)
      msg_obj.send(first_key).should_not be_nil
    end
  end

  describe "#encode" do
    if version == 1
      it "should return a Schemata-encoded json string, with a V1 hash also in the raw payload" do
        msg_obj = component.send(mock_method, 1)
        json = msg_obj.encode
        json_hash = Yajl::Parser.parse(json)

        json_hash.should have_key "V1"
        json_hash.should have_key "min_version"

        data = Schemata::HashCopyHelpers.deep_copy(json_hash["V1"])

        json_hash.delete("V1")
        json_hash.delete("min_version")

        json_hash.should == data
      end
    else
      it "should return a Schemata-encoded json string, with no raw payload" do
        msg_obj = component.send(mock_method, version)
        json = msg_obj.encode
        json_hash = Yajl::Parser.parse(json)

        1.upto(version) do |i|
          json_hash.should have_key "V#{i}"
        end
        json_hash.should have_key "min_version"

        data = Schemata::HashCopyHelpers.deep_copy(json_hash["V#{version}"])
        1.upto(version) do |i|
          json_hash.delete("V#{i}")
        end
        json_hash.delete("min_version")

        json_hash.should be_empty
      end
    end
  end

  described_class.schema.schemas.keys.each do |attr|
    describe "##{attr}" do
      it "should return the attribute if it was specified at instantiation" do
        mock_value = component.send(mock_method, version).contents[attr]
        msg_obj = message.new({ attr => mock_value })
        msg_obj.send(attr).should == mock_value
      end

      it "should return the attribute if it was set with an attr writer" do
        mock_value = component.send(mock_method, version).contents[attr]
        msg_obj = message.new
        msg_obj.send("#{attr}=", mock_value)
        msg_obj.send(attr).should == mock_value
      end

      it "should return nil if the attribute was never set" do
        msg_obj = message.new
        msg_obj.send(attr).should be_nil
      end

      if described_class.schema.optional_keys.include? attr
        context "the attribute is optional" do
          it "should allow nil values during instantiation" do
            mock_value = component.send(mock_method, version).contents[attr]
            hash = { attr => mock_value }
            msg_obj = message.new(hash)
          end

          it "should be able to set the attribute to nil" do
            msg_obj = message.new
            msg_obj.send("#{attr}=", nil)
          end
        end
      end
    end

    describe "##{attr}=" do
      it "should change the attribute and return the new value" do
        mock_value = component.send(mock_method, version).contents[attr]
        msg_obj = message.new({ attr => mock_value })
        ret = (msg_obj.send("#{attr}=", mock_value))
        msg_obj.send(attr).should == mock_value
        ret.should == mock_value
      end

      unless described_class.schema.schemas[attr].kind_of? Membrane::Schema::Any
        it "should raise an error if the wrong type is written" do
          mock_value = component.send(mock_method, version).contents[attr]

          schema = message.schema.schemas[attr]
          unallowed_classes = get_unallowed_classes(schema)
          bad_value = default_value(unallowed_classes.to_a[0])

          msg_obj = message.new

          expect {
            msg_obj.send("#{attr}=", bad_value)
          }.to raise_error(Schemata::UpdateAttributeError)
        end
      end
    end
  end
end
