require 'schemata/common/msgtypebase'

module Schemata
  module Dea
    module FindDropletRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/find_droplet_request/*.rb'].each do |file|
  require file
end
