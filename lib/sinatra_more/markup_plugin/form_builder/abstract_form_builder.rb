class AbstractFormBuilder
  attr_accessor :template, :object

  def initialize(template, object)
    raise "FormBuilder template must be initialized!" unless template
    raise "FormBuilder object must be initialized!" unless object
    @template = template
    @object   = object
  end

  # f.error_messages
  def error_messages(options={})
    @template.error_messages_for(@object, options)
  end

  # f.label :username, :caption => "Nickname"
  def label(field, options={})
    options.reverse_merge!(:caption => field.to_s.titleize)
    @template.label_tag(field_id(field), options)
  end

  # f.hidden_field :session_id, :value => "45"
  def hidden_field(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.hidden_field_tag field_name(field), options
  end

  # f.text_field :username, :value => "(blank)", :id => 'username'
  def text_field(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.text_field_tag field_name(field), options
  end

  # f.text_area :summary, :value => "(enter summary)", :id => 'summary'
  def text_area(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.text_area_tag field_name(field), options
  end

  # f.password_field :password, :id => 'password'
  def password_field(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.password_field_tag field_name(field), options
  end

  # f.check_box :remember_me, :value => 'true'
  def check_box(field, options={})
    options.reverse_merge!(:value => field_value(field), :id => field_id(field))
    @template.check_box_tag field_name(field), options
  end

  # f.file_field :photo, :class => 'avatar'
  def file_field(field, options={})
    options.reverse_merge!(:id => field_id(field))
    @template.file_field_tag field_name(field), options
  end

  # f.submit "Update", :class => 'large'
  def submit(caption="Submit", options={})
    @template.submit_tag caption, options
  end


  protected

  # Returns the known field types for a formbuilder
  def self.field_types
    [:text_field, :text_area, :password_field, :file_field, :hidden_field, :check_box]
  end

  # Returns the object's models name
  #   => user_assignment
  def object_name
    object.class.to_s.underscore
  end

  # Returns the value for the object's field
  # field_value(:username) => "Joey"
  def field_value(field)
    @object && @object.respond_to?(field) ? @object.send(field) : ""
  end

  # Returns the name for the given field
  # field_name(:username) => "user[username]"
  def field_name(field)
    "#{object_name}[#{field}]"
  end

  # Returns the id for the given field
  # field_id(:username) => "user_username"
  def field_id(field)
    "#{object_name}_#{field}"
  end
end
