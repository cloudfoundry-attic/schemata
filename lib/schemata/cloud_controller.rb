Dir.glob(File.dirname(__FILE__) + '/cloud_controller/*.rb', &method(:require))
require 'schemata/common/componentbase'

module Schemata
  module CloudController
    extend Schemata::ComponentBase
  end
end
