class StandardFormBuilder < AbstractFormBuilder
  def text_field_block(field, options={})
    @template.content_block_tag(:p) do
      html =  label(field)
      html << text_field(field, options)
    end
  end
  
  def text_area_block(field, options={})
    @template.content_block_tag(:p) do
      html =  label(field)
      html << text_area(field, options)
    end
  end
  
  def password_field_block(field, options={})
    @template.content_block_tag(:p) do
      html =  label(field)
      html << password_field(field, options)
    end
  end
  
  def file_field_block(field, options={})
    @template.content_block_tag(:p) do
      html =  label(field)
      html << file_field(field, options)
    end
  end
  
  def submit_block(caption)
    @template.content_block_tag(:p) do
      @template.submit_tag(caption)
    end
  end
end