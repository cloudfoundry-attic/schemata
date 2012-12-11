require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module UpdateRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/update_request/*.rb'].each do |file|
  require file
end
