def set_current_version(msg_type, version)
  msg_type.stub(:current_version).and_return(version)
  @curr_class = msg_type.current_class

  @future_versions = {}
  msg_type::constants.each do |v|
    next if !is_message_version?(v) || !greater_version?(v, version)
    @future_versions[v] = msg_type::const_get(v)
    msg_type.send(:remove_const, v)
  end
end

def reset_version(msg_type)
  @future_versions.each do |v, klass|
    msg_type::const_set(v, klass)
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
