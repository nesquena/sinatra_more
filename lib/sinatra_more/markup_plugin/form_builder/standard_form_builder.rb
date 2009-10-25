class StandardFormBuilder < AbstractFormBuilder
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

  def submit_block(caption)
    @template.content_block_tag(:p) do
      @template.submit_tag(caption)
    end
  end
end
