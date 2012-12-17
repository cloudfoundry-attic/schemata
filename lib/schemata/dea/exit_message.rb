require 'schemata/common/msgtypebase'

module Schemata
  module Dea
    module ExitMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/exit_message/*.rb'].each do |file|
  require file
end
