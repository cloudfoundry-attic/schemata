require 'schemata/component2/bar'

module Schemata
  module Component2

    def self.mock_bar(version=Bar.current_version)
      Bar::const_get("V#{version}").mock
    end
  end
end
