require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::DiscoverRequest do
  it_behaves_like "a message type"
end

describe Schemata::DEA::DiscoverRequest::V1 do
  it_behaves_like "a message"
end
