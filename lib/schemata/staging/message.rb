require 'schemata/common/msgtypebase'

module Schemata
  module Staging
    module Message
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/message/*.rb'].each do |file|
  require file
end
