require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Bar
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + "/bar/*.rb"].each do |file|
  require file
end

