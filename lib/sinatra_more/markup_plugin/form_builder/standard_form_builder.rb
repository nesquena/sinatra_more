class StandardFormBuilder < AbstractFormBuilder
  
  # text_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # text_area_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # password_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  # file_field_block(:username, { :class => 'long' }, { :class => 'wide-label' })
  self.field_types.each do |field_type|
    class_eval <<-EOF
    def #{field_type}_block(field, options={}, label_options={})
      label_options.reverse_merge!(:caption => options.delete(:caption)) if options[:caption]
      @template.content_block_tag(:p) do
        html =  label(field, label_options)
        html << #{field_type}(field, options)
      end
    end
    EOF
  end

  # submit_block("Update")
  def submit_block(caption)
    @template.content_block_tag(:p) do
      @template.submit_tag(caption)
    end
  end
end
