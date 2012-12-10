require 'schemata/common/msgtypebase'

module Schemata
  module DEA
    module AdvertiseMessage
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/advertise_message/*.rb'].each do |file|
  require file
end
