require 'schemata/health_manager'
require 'spec_helper'

describe Schemata::HealthManager::HealthResponse do
  it_behaves_like "a message type"
end

Schemata::HealthManager::HealthResponse.versions.each do |v|
  describe Schemata::HealthManager::HealthResponse::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
