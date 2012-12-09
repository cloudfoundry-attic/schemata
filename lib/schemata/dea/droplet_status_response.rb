require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module DropletStatusResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/droplet_status_response/*.rb'].each do |file|
  require file
end
