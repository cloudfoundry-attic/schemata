require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::ExitMessage do
  it_behaves_like "a message type"
end

describe Schemata::DEA::ExitMessage::V1 do
  it_behaves_like "a message"
end
