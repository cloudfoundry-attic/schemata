require 'schemata/health_manager'
require 'spec_helper'

describe Schemata::HealthManager::StatusCrashedResponse do
  it_behaves_like "a message type"
end

Schemata::HealthManager::StatusCrashedResponse.versions.each do |v|
  describe Schemata::HealthManager::StatusCrashedResponse::const_get("V#{v}") do
    it_behaves_like "a message"
  end
end
