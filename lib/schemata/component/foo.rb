require 'schemata/common/msgtypebase'

module Schemata
  module Component
    module Foo
      extend Schemata::MessageTypeBase
    end
  end
end

Dir[File.dirname(__FILE__) + '/foo/*.rb'].each do |file|
  require file
end

