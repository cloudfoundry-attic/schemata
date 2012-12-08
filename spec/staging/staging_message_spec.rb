require 'yajl'
require 'support/helpers'
require 'schemata/staging'

describe Schemata::Staging do
  it_behaves_like "a schemata component", [1, 2]
end

describe Schemata::Staging::Message do
  it_behaves_like "a message type", [1, 2]
end

describe Schemata::Staging::Message::V1 do
  it_behaves_like "a message"
end

describe Schemata::Staging::Message::V2 do
  it_behaves_like "a message"
end
