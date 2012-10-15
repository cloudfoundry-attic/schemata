Dir[File.dirname(__FILE__) + '/foo/*.rb'].each do |file|
  require file
end

module Schemata
  module Component
    module Foo
      def self.current_version
        return @current_version if @current_version
        klasses = self.constants.select { |x| x=~ /^V[0-9]+$/ }
        versions = klasses.map { |x| x[1..-1].to_i }
        @current_version = versions.max
      end

      def self.current_class
        self::const_get("V#{current_version}")
      end
    end
  end
end
