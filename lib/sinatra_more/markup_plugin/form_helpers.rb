module SinatraMore
  module FormHelpers
    # form_for @user, '/register', :id => 'register' do |f| ... end
    def form_for(object, url, settings={}, &block)
      configured_builder = settings[:builder] || self.options.default_builder.constantize
      settings.reverse_merge!(:method => 'post', :action => url)
      settings[:enctype] = "multipart/form-data" if settings.delete(:multipart)
      form_html = capture_html(configured_builder.new(self, object), &block)
      concat_content content_tag('form', form_html, settings)
    end

    # form_tag '/register' do ... end
    def form_tag(url, options={}, &block)
      options.reverse_merge!(:method => 'post', :action => url)
      concat_content content_tag('form', capture_html(&block), options)
    end
    
    # field_set_tag("Office", :class => 'office-set')
    # parameters: legend_text=nil, options={}
    def field_set_tag(*args, &block)
      options = args.extract_options!
      legend_text = args[0].is_a?(String) ? args.first : nil
      legend_html = legend_text.blank? ? '' : content_tag(:legend, legend_text)
      field_set_content = legend_html + capture_html(&block)
      concat_content content_tag('fieldset', field_set_content, options)
    end

    # error_messages_for @user
    def error_messages_for(record, options={})
      return "" if record.blank? or record.errors.none?
      options.reverse_merge!(:header_message => "The #{record.class.to_s.downcase} could not be saved!")
      error_messages = record.errors.full_messages
      content_block_tag(:div, :class => 'field-errors', :concat => false) do
        html = content_tag(:p, options.delete(:header_message))
        html << content_block_tag(:ul, :class => 'field-errors', :concat => false) do
          error_messages.collect { |er| content_tag(:li, er) }.join("\n")
        end
      end
    end

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

    # text_field_tag :username, :class => 'long'
    def text_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:text, options)
    end

    # text_area_tag :username, :class => 'long'
    def text_area_tag(name, options={})
      options.reverse_merge!(:name => name)
      content_tag(:textarea, '', options)
    end

    # password_field_tag :password, :class => 'long'
    def password_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:password, options)
    end

    # field_field_tag :photo, :class => 'long'
    def file_field_tag(name, options={})
      options.reverse_merge!(:name => name)
      input_tag(:file, options)
    end

    # submit_tag "Create", :class => 'success'
    def submit_tag(caption, options={})
      options.reverse_merge!(:value => caption)
      input_tag(:submit, options)
    end
  end
end
