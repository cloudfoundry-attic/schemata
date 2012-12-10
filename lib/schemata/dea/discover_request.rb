require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module DiscoverRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/discover_request/*.rb'].each do |file|
  require file
end
