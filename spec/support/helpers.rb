def set_current_version(version)
  Schemata::Component::Foo.stub(:current_version).and_return(version)
  @curr_class = Schemata::Component::Foo.current_class

  @future_versions = {}
  Schemata::Component::Foo::constants.each do |v|
    next if !is_message_version?(v) || !greater_version?(v, version)
    @future_versions[v] = Schemata::Component::Foo::const_get(v)
    Schemata::Component::Foo.send(:remove_const, v)
  end
end

def reset_version
  @future_versions.each do |v, klass|
    Schemata::Component::Foo::const_set(v, klass)
  end
  @future_versions
end

def is_message_version?(constant)
  !!(constant =~ /^V[0-9]+$/)
end

def greater_version?(version, benchmark)
  version = version[1..-1].to_i
  version > benchmark
end
