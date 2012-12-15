require 'schemata/health_manager'
require 'spec_helper'

describe Schemata::HealthManager::HealthRequest do
  it_behaves_like "a message type"
end

Schemata::HealthManager::HealthRequest.versions.each do |v|
  describe Schemata::HealthManager::HealthRequest::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
