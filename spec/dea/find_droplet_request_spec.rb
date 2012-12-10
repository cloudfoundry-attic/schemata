require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::FindDropletRequest do
  it_behaves_like "a message type"
end

describe Schemata::DEA::FindDropletRequest::V1 do
  it_behaves_like "a message"
end
