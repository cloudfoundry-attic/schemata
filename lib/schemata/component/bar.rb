require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Bar
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.expand_path("../bar/*.rb", __FILE__)].each { |file| require file }

