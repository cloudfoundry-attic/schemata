Dir.glob(File.dirname(__FILE__) + '/health_manager/*.rb', &method(:require))
require 'schemata/common/componentbase'

module Schemata
  module HealthManager
    extend Schemata::ComponentBase
  end
end
