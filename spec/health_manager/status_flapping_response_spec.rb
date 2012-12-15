require 'schemata/health_manager'
require 'spec_helper'

describe Schemata::HealthManager::StatusFlappingResponse do
  it_behaves_like "a message type"
end

Schemata::HealthManager::StatusFlappingResponse.versions.each do |v|
  describe Schemata::HealthManager::StatusFlappingResponse::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
