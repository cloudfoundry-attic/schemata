require 'schemata/router'
require 'spec_helper'

describe Schemata::Router::StartMessage do
  it_behaves_like "a message type"
end

describe Schemata::Router::StartMessage::V1 do
  it_behaves_like "a message"
end
