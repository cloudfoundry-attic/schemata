require 'schemata/dea'
require 'spec_helper'

describe Schemata::DEA::FindDropletRequest do
  it_behaves_like "a message type"
end

describe Schemata::DEA::FindDropletRequest::V1 do
  it_behaves_like "a message"

  it "should stringify the 'states' field when it is given to the constructor as a symbol" do
    hash = {
      "droplet" => "deadbeef",
      "states" => [:RUNNING],
      "version" => "0.1.0",
    }

    msg_obj = Schemata::DEA::FindDropletRequest::V1.new(hash)
    msg_obj.states.should =~ ["RUNNING"]
  end

  it "should stringify the 'states' field when a symbold is passed ot the attr writer" do
    msg_obj = Schemata::DEA.mock_find_droplet_request
    msg_obj.states = [:RUNNING]
    msg_obj.states.should =~ ["RUNNING"]
  end
end
