require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module ExitMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/exit_message/*.rb'].each do |file|
  require file
end
