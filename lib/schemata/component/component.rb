require 'schemata/component/bar'
require 'schemata/component/foo'

module Schemata
  module Component

    def self.mock_foo(version=Foo.current_version)
      Foo::const_get("V#{version}").mock
    end

    def self.mock_bar(version=Bar.current_version)
      Bar::const_get("V#{version}").mock
    end
  end
end
