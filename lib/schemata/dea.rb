Dir.glob(File.dirname(__FILE__) + '/dea/*.rb', &method(:require))
require 'schemata/common/componentbase'

module Schemata
  module DEA
    extend Schemata::ComponentBase
  end
end
