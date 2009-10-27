unless 5.respond_to?(:days)
  require 'active_support/core_ext/object/misc'
  require 'active_support/core_ext/date'
  require 'active_support/core_ext/time'
  require 'active_support/core_ext/numeric'
  require 'active_support/duration'
end
