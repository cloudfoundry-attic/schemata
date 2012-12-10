require 'schemata/router'
require 'spec_helper'

describe Schemata::Router::RegisterRequest do
  it_behaves_like "a message type"
end

describe Schemata::Router::RegisterRequest::V1 do
  it_behaves_like "a message"
end
