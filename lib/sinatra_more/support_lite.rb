# This is for adding specific methods that are required by sinatra_more if activesupport isn't required

unless String.new.respond_to?(:titleize)
  require 'active_support/inflector'
end

unless Hash.new.respond_to?(:reverse_merge!)
  module HashExtensions
    def reverse_merge(other_hash)
      other_hash.merge(self)
    end
    def reverse_merge!(other_hash)
      replace(reverse_merge(other_hash))
    end
  end
end

unless Hash.new.respond_to?(:symbolize_keys!)
  module HashExtensions
    def symbolize_keys
      inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end
    def symbolize_keys!
      self.replace(self.symbolize_keys)
    end
  end
end

unless Array.new.respond_to?(:extract_options!)
  module ArrayExtensions
    def extract_options!
      last.is_a?(::Hash) ? pop : {}
    end
  end
end

Hash.send(:include, HashExtensions) if defined?(HashExtensions)
Array.send(:include, ArrayExtensions) if defined?(ArrayExtensions)
