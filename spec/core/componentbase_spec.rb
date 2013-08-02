require 'spec_helper'
require 'schemata/core/componentbase'

describe Schemata::ComponentBase do
  let(:component) { Schemata::Component }

  describe '#require_message_classes' do
    subject { component.require_message_classes }

    it 'require the full path as consumers will need absolute not relative paths' do
      Dir.should_receive(:glob).with(File.expand_path("../../../lib/schemata/component/*.rb", __FILE__))
      subject
    end
  end
end


