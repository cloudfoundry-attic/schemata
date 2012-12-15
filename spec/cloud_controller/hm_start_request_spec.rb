require "schemata/cloud_controller"

describe Schemata::CloudController::HmStartRequest do
  it_behaves_like "a message type"
end

Schemata::CloudController::HmStartRequest.versions.each do |v|
  describe Schemata::CloudController::HmStartRequest::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
