Dir.glob(File.dirname(__FILE__) + '/staging/*.rb', &method(:require))
require 'schemata/common/componentbase'

module Schemata
  module Staging
    extend Schemata::ComponentBase
  end
end
