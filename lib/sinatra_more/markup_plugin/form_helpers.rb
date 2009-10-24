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
    def label_tag(name, options={})
      options.reverse_merge!(:caption => name.to_s.titleize)
      content_tag(:label, options.delete(:caption) + ": ", :for => name)
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
