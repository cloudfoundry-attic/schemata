require 'schemata/common/msgtypebase'

module Schemata
  module Router
    module StartMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/start_message/*.rb'].each do |file|
  require file
end
