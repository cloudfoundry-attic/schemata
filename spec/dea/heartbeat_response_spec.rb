require 'yajl'
require 'support/helpers'
require 'schemata/dea'

describe Schemata::DEA do
  it_behaves_like "a schemata component", [1]
end

describe Schemata::DEA::HeartbeatResponse do
  it_behaves_like "a message type", [1]
end

describe Schemata::DEA::HeartbeatResponse::V1 do
  it_behaves_like "a message"
end
