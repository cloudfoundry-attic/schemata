require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::DropletStatusResponse do
  it_behaves_like "a message type"
end

describe Schemata::DEA::DropletStatusResponse::V1 do
  it_behaves_like "a message"
end
