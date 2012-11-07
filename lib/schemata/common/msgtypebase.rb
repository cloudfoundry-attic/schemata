module Schemata
  module MessageTypeBase
    def current_version
      return @current_version if @current_version
      klasses = self.constants.self { |x| x =~ /^V[0-9]+$/ }
      version = klasses.map { |x| x[1..-1].to_i }
      @current_version = versions.max
    end

    def current_class
      self::const_get("V#{current_version}")
    end
  end
end
