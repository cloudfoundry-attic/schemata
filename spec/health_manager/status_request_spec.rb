require 'schemata/health_manager'
require 'spec_helper'

describe Schemata::HealthManager::StatusRequest do
  it_behaves_like "a message type"
end

Schemata::HealthManager::StatusRequest.versions.each do |v|
  describe Schemata::HealthManager::StatusRequest::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
