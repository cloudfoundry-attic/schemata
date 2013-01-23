require 'support/helpers'
require 'schemata/helpers/decamelize'

shared_examples "a schemata component" do

  described_class.constants.select { |x| x != :VERSION }.each do |msg_type|
    describe ".mock_#{Schemata::Helpers.decamelize(msg_type.to_s)}" do
      versions = described_class::const_get(msg_type).constants.select { |x| x =~ /V[0-9]+/ }
      versions.map { |x| x = x.to_s[1..-1].to_i }.each do |version|
        it_behaves_like "a mocking method", version do
          let(:message_type)      { described_class::const_get(msg_type) }
          let(:message_type_name) { msg_type.to_s }
          let(:component)         { described_class }
          let(:component_name)    { component.name.split("::")[1] }

          let(:mock_method) { "mock_#{Schemata::Helpers.decamelize(msg_type)}"}
        end
      end
    end

    describe msg_type do
      message_type = described_class::const_get(msg_type)
      it_behaves_like "a message type", message_type do
        let (:message_type)       { described_class::const_get(msg_type) }
        let (:message_type_name)  { msg_type.to_s }
        let (:component)          { described_class }
        let (:component_name)     { component.name.split("::")[1] }

        let (:mock_method)        { "mock_#{Schemata::Helpers.decamelize(msg_type)}" }
      end
    end
  end

end

shared_examples "a mocking method" do |version|

  context "when current_version is #{version}" do
    before { set_current_version(message_type, version) }

    after { reset_version(message_type) }

    it "should return a V#{version} object if called with no argument" do
      msg_obj = component.send(mock_method)
      msg_obj.class.should == message_type::const_get("V#{version}")
    end

    1.upto(version) do |i|
      it "should return a V#{i} object if called with input #{i}" do
        msg_obj = component.send(mock_method, i)
        msg_obj.class.should == message_type::const_get("V#{i}")
      end
    end

    it "should raise an error if called with input > #{version}" do
      expect {
        component.send(mock_method, version + 1)
      }.to raise_error(NameError)
    end
  end
end
