require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::FindDropletResponse do
  it_behaves_like "a message type"
end

describe Schemata::DEA::FindDropletResponse::V1 do
  it_behaves_like "a message"
end
