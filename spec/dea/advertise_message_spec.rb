require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::AdvertiseMessage do
  it_behaves_like "a message type"
end

describe Schemata::DEA::AdvertiseMessage::V1 do
  it_behaves_like "a message"
end
