require "schemata/common/msgtypebase"

module Schemata
  module Dea
    module FindDropletResponse
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/find_droplet_response/*.rb'].each do |file|
  require file
end
