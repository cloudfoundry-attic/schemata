require 'schemata/cloud_controller'
require 'spec_helper'

describe Schemata::CloudController::DropletUpdatedMessage do
  it_behaves_like "a message type"
end

describe Schemata::CloudController::DropletUpdatedMessage::V1 do
  it_behaves_like "a message"
end
