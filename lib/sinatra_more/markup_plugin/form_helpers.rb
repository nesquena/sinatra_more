module SinatraMore
  module FormHelpers
    # form_for @user, '/register', :id => 'register'
    def form_for(object, url, settings={}, &block)
      default_builder = settings[:builder] || self.options.default_builder.constantize
      settings.reverse_merge!(:method => 'post', :action => url)
      settings[:enctype] = "multipart/form-data" if settings.delete(:multipart)
      # TODO make this work with erb!!
      form_html = capture_haml(default_builder.new(self, object), &block)
      haml_concat content_tag('form', form_html, settings)
    end

    # form_tag '/register' do ... end
    def form_tag(url, options={}, &block)
      options.reverse_merge!(:method => 'post', :action => url)
      # TODO make this work with erb!!
      haml_concat content_tag('form', capture_haml(&block), options)
    end
    
    def field_set_tag(legend=nil, options={}, &block)
      # TODO make this work with erb!!
      field_set_content = ''
      field_set_content << content_tag(:legend, legend)  if legend.present?
      field_set_content << capture_haml(&block)
      haml_concat content_tag('fieldset', field_set_content, options)
    end

    # error_messages_for @user
    def error_messages_for(record, options={})
      return "" if record.blank? or record.errors.none?
      options.reverse_merge!(:header_message => "The #{record.class.to_s.downcase} could not be saved!")
      error_messages = record.errors.full_messages
      content_block_tag(:div, :class => 'field-errors') do
        html = content_tag(:p, options.delete(:header_message))
        html << content_block_tag(:ul, :class => 'field-errors') do
          error_messages.collect { |er| content_tag(:li, er) }.join("\n")
        end
      end
    end

    # label_tag :username
    def label_tag(name, options={}, &block)
      options.reverse_merge!(:caption => name.to_s.titleize, :for => name)
      caption_text = options.delete(:caption) + ": "
      # TODO make this work with erb!!
      if block_given? # label with inner content
        label_content = caption_text + capture_haml(&block)
        haml_concat(content_tag(:label, label_content, options))
      else # regular label
        content_tag(:label, caption_text, options)
      end
    end

    # text_field_tag :username
    def text_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:text, options)
    end

    # text_field_tag :username
    def text_area_tag(name, options={})
      options.reverse_merge!(:name => name)
      content_tag(:textarea, '', options)
    end

    # password_field_tag :password
    def password_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:password, options)
    end

    # field_field_tag
    def file_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:file, options)
    end

    # submit_tag "Create"
    def submit_tag(caption, options={})
      options.reverse_merge!(:value => caption)
      input_tag(:submit, options)
    end
  end
end
