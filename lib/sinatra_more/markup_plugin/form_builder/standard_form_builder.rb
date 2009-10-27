class StandardFormBuilder < AbstractFormBuilder
  
  # text_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # text_area_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # password_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # file_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  (self.field_types - [:hidden_field]).each do |field_type|
    class_eval <<-EOF
    def #{field_type}_block(field, options={}, label_options={})
      label_options.reverse_merge!(:caption => options.delete(:caption)) if options[:caption]
      field_html = label(field, label_options)
      field_html << #{field_type}(field, options)
      @template.content_tag(:p, field_html)
    end
    EOF
  end

  # submit_block("Update")
  def submit_block(caption, options={})
    submit_html = @template.submit_tag(caption, options)
    @template.content_tag(:p, submit_html)
  end
end
