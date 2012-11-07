Dir[File.dirname(__FILE__) + "/bar/*.rb"].each do |file|
  require file
end
require 'schemata/common/msgtypebase'

module Schemata
  module CloudController
    module Bar
      extend Schemata::MessageTypeBase
    end
  end
end
