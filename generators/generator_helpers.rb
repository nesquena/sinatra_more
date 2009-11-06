module SinatraMore
  module GeneratorHelpers    
    # root_path('public/javascripts/example.js')
    def root_path(*paths)
      base_path = File.join(path, name)
      return base_path unless paths.present?
      File.join(base_path, *paths)
    end
    
    # Returns true if the option passed is a valid choice for component
    # valid_option?('rr', :mock)
    def valid_option?(option, component)
      return available_options_for(component).include? option.to_sym
    end
  
    # Returns the related module for a given component and option
    # generator_module_for('rr', :mock)
    def generator_module_for(option, component)
      "SinatraMore::#{option.to_s.capitalize}#{component.to_s.capitalize}Gen".constantize
    end
  end
end