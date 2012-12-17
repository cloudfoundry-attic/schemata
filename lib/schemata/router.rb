Dir.glob(File.dirname(__FILE__) + '/router/*.rb', &method(:require))
require 'schemata/common/componentbase'

module Schemata
  module Router
    extend Schemata::ComponentBase
  end
end
