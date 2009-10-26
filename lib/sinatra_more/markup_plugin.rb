require File.dirname(__FILE__) + '/markup_plugin/form_builder/abstract_form_builder'
require File.dirname(__FILE__) + '/markup_plugin/form_builder/standard_form_builder'
Dir[File.dirname(__FILE__) + '/markup_plugin/*.rb'].each {|file| load file }

module SinatraMore
  module MarkupPlugin
    def self.registered(app)
      app.helpers OutputHelpers
      app.helpers TagHelpers
      app.helpers AssetTagHelpers
      app.helpers FormHelpers
      app.helpers FormatHelpers
    end
  end  
end