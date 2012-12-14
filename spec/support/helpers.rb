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

def decamelize(str)
  words = []
  curr_word = ""
  0.upto(str.length - 1) do |i|
    ch = str[i]
    if ch =~ /[A-Z]/
      words.push(curr_word)
      curr_word = ""
    end
    curr_word += ch
  end
  words.push(curr_word)
  words.map! { |x| x.downcase }

  # If the first letter is capitalized, then the first word here is empty
  words.shift if words[0] == ""

  words.join('_')
end

def num_mandatory_fields(msg_obj)
  optional = msg_obj.class.schema.optional_keys
  mandatory = Set.new(msg_obj.class.schema.schemas.keys)
  diff = mandatory - optional
  return diff.size
end

def get_allowed_classes(schema)
  case schema
  when Membrane::Schema::Bool
    return Set.new([TrueClass, FalseClass])
  when Membrane::Schema::Enum
    return Set.new(schema.elem_schemas.map {|x| get_allowed_classes(x)}).flatten
  when Membrane::Schema::Class
    return Set.new([schema.klass])
  when Membrane::Schema::Record
    return Set.new([Hash])
  when Membrane::Schema::List
    return Set.new([Array])
  end
end

def get_unallowed_classes(schema)
  all_classes = Set.new([Integer, String, Float, TrueClass, FalseClass, NilClass, Hash, Array])
  allowed_classes = get_allowed_classes(schema)
  all_classes - allowed_classes
end

def default_value(klass)
  # Yes this is silly
  if klass == Integer
    return 0
  elsif klass == String
    return "foo"
  elsif klass == Float
    return 3.14
  elsif klass == TrueClass
    return true
  elsif klass == FalseClass
    return false
  elsif klass == NilClass
    return nil
  elsif klass == Hash
    return {}
  elsif klass == Array
    return []
  else
  end
end
