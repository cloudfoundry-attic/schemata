require 'schemata/common/msgtypebase'

module Schemata
  module CloudController
    module HmStopRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/hm_stop_request/*.rb'].each do |file|
  require file
end
