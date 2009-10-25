class AbstractFormBuilder
  attr_accessor :template, :object
  
  def initialize(template, object)
    raise "FormBuilder template must be initialized!" unless template
    raise "FormBuilder object must be initialized!" unless object
    @template = template
    @object   = object
  end
  
  def error_messages(options={})
    @template.error_messages_for(@object, options)
  end
  
  def label(field, options={})
    options.reverse_merge!(:caption => field.to_s.titleize)
    @template.label_tag(field_id(field), options)
  end
  
  def text_field(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.text_field_tag field_name(field), options
  end
  
  def text_area(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.text_area_tag field_name(field), options
  end
  
  def password_field(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.password_field_tag field_name(field), options
  end
  
  def file_field(field, options={})
    options.reverse_merge!(:id => field_id(field))
    @template.file_field_tag field_name(field), options
  end
  
  def submit(caption, options={})
    @template.submit_tag caption, options
  end
  
  protected
  
  def self.field_types
    [:text_field, :text_area, :password_field, :file_field]
  end
  
  private
  
  def object_name
    object.class.to_s.underscore
  end
  
  def field_value(field)
    @object && @object.respond_to?(field) ? @object.send(field) : ""
  end
  
  def field_name(field)
    "#{object_name}[#{field}]"
  end
  
  def field_id(field)
    "#{object_name}_#{field}"
  end
end