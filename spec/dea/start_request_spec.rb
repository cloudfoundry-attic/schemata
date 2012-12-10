require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::StartRequest do
  it_behaves_like "a message type"
end

describe Schemata::DEA::StartRequest::V1 do
  it_behaves_like "a message"
end
