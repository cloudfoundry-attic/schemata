require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::HelloMessage do
  it_behaves_like "a message type"
end

describe Schemata::DEA::HelloMessage::V1 do
  it_behaves_like "a message"
end
