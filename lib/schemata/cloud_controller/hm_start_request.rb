require 'schemata/common/msgtypebase'

module Schemata
  module CloudController
    module HmStartRequest
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/hm_start_request/*.rb'].each do |file|
  require file
end
