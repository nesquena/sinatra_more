module SinatraMore
  module FormHelpers
    # Constructs a form for object using given or default form_builder
    # form_for @user, '/register', :id => 'register' do |f| ... end
    def form_for(object, url, settings={}, &block)
      default_builder = self.respond_to?(:options) && self.options.default_builder
      configured_builder = settings[:builder] || default_builder || 'StandardFormBuilder'
      configured_builder = configured_builder.constantize if configured_builder.is_a?(String)
      settings.reverse_merge!(:method => 'post', :action => url)
      settings[:enctype] = "multipart/form-data" if settings.delete(:multipart)
      form_html = capture_html(configured_builder.new(self, object), &block)
      concat_content content_tag('form', form_html, settings)
    end

    # Constructs a form without object based on options
    # form_tag '/register' do ... end
    def form_tag(url, options={}, &block)
      options.reverse_merge!(:method => 'post', :action => url)
      concat_content content_tag('form', capture_html(&block), options)
    end
    
    # Constructs a field_set to group fields with given options
    # field_set_tag("Office", :class => 'office-set')
    # parameters: legend_text=nil, options={}
    def field_set_tag(*args, &block)
      options = args.extract_options!
      legend_text = args[0].is_a?(String) ? args.first : nil
      legend_html = legend_text.blank? ? '' : content_tag(:legend, legend_text)
      field_set_content = legend_html + capture_html(&block)
      concat_content content_tag('fieldset', field_set_content, options)
    end

    # Constructs list html for the errors for a given object
    # error_messages_for @user
    def error_messages_for(record, options={})
      return "" if record.blank? or record.errors.none?
      options.reverse_merge!(:header_message => "The #{record.class.to_s.downcase} could not be saved!")
      error_messages = record.errors.full_messages
      error_items = error_messages.collect { |er| content_tag(:li, er) }.join("\n")
      error_html = content_tag(:p, options.delete(:header_message))
      error_html << content_block_tag(:ul, error_items, :class => 'errors-list')
      content_block_tag(:div, error_html, :class => 'field-errors')
    end

    # Constructs a label tag from the given options
    # label_tag :username, :class => 'long-label'
    # label_tag :username, :class => 'long-label' do ... end
    def label_tag(name, options={}, &block)
      options.reverse_merge!(:caption => name.to_s.titleize, :for => name)
      caption_text = options.delete(:caption) + ": "
      if block_given? # label with inner content
        label_content = caption_text + capture_html(&block)
        concat_content(content_tag(:label, label_content, options))
      else # regular label
        content_tag(:label, caption_text, options)
      end
    end

    # Constructs a text field input from the given options
    # text_field_tag :username, :class => 'long'
    def text_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:text, options)
    end

    # Constructs a text area input from the given options
    # text_area_tag :username, :class => 'long'
    def text_area_tag(name, options={})
      options.reverse_merge!(:name => name)
      content_tag(:textarea, '', options)
    end

    # Constructs a password field input from the given options
    # password_field_tag :password, :class => 'long'
    def password_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:password, options)
    end

    # Constructs a file field input from the given options
    # file_field_tag :photo, :class => 'long'
    def file_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:file, options)
    end

    # Constructs a submit button from the given options
    # submit_tag "Create", :class => 'success'
    def submit_tag(caption="Submit", options={})
      options.reverse_merge!(:value => caption)
      input_tag(:submit, options)
    end
  end
end
