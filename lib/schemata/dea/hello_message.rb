require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module HelloMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/hello_message/*.rb'].each do |file|
  require file
end
