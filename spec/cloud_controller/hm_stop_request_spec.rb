require 'schemata/cloud_controller'
require 'spec_helper'

describe Schemata::CloudController::HmStopRequest do
  it_behaves_like "a message type"
end

Schemata::CloudController::HmStopRequest.versions.each do |v|
  describe Schemata::CloudController::HmStopRequest::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
