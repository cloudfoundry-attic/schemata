require 'schemata/common/msgtypebase'

module Schemata
  module Router
    module RegisterRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/register_request/*.rb'].each do |file|
  require file
end
