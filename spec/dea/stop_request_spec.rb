require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::StopRequest do
  it_behaves_like "a message type"
end

describe Schemata::DEA::StopRequest::V1 do
  it_behaves_like "a message"
end
