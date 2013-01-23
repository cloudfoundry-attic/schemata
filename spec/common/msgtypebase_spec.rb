require 'spec_helper'
require 'schemata/dea'
require 'schemata/common/msgtypebase'

describe Schemata::MessageTypeBase do
  let(:msgtype) { Schemata::Dea::AdvertiseMessage }

  describe '#require_message_versions' do
    subject { msgtype.require_message_versions }

    it 'require the full path as consumers will need absolute not relative paths' do
      Dir.should_receive(:glob).with(File.expand_path("../../../lib/schemata/dea/advertise_message/*.rb", __FILE__))
      subject
    end
  end
end