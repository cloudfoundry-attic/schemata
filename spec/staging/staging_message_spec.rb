require 'schemata/staging'
require 'spec_helper'

describe Schemata::Staging::Message do
  it_behaves_like "a message type"
end

describe Schemata::Staging::Message::V1 do
  it_behaves_like "a message"
end

describe Schemata::Staging::Message::V2 do
  it_behaves_like "a message"
end
