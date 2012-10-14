require File.expand_path('../bar_v11', __FILE__)
require File.expand_path('../bar_v10', __FILE__)

class Bar
  CURRENT = Bar::V11
  PREVIOUS = Bar::V10
end
