require 'schemata/common/msgtypebase'

module Schemata
  module CloudController
    module DropletUpdatedMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/droplet_updated_message/*.rb'].each do |file|
  require file
end
