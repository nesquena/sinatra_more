module SinatraMore
  module TagHelpers
    # Creates an html input field with given type and options
    # input_tag :text, :class => "test"
    def input_tag(type, options = {})
      options.reverse_merge!(:type => type)
      [:checked, :disabled].each { |attr| options[attr] = attr.to_s if options[attr]  }
      tag(:input, options)
    end

    # Creates an html tag with given name, content and options
    # content_tag(:p, "hello", :class => 'light')
    # content_tag(:p, :class => 'dark') do ... end
    # parameters: content_tag(name, content=nil, options={}, &block)
    def content_tag(*args, &block)
      name = args.first
      options = args.extract_options!
      tag_html = block_given? ? capture_html(&block) : args[1]
      tag_result = tag(name, options.merge(:content => tag_html))
      block_is_template?(block) ? concat_content(tag_result) : tag_result
    end

    # Creates an html tag with the given name and options
    # tag(:br, :style => 'clear:both')
    # tag(:p, :content => "hello", :class => 'large')
    def tag(name, options={})
      content = options.delete(:content)
      html_attrs = options.collect { |a, v| v.blank? ? nil : "#{a}=\"#{v}\"" }.compact.join(" ")
      base_tag = (html_attrs.present? ? "<#{name} #{html_attrs}" : "<#{name}")
      base_tag << (content ? ">#{content}</#{name}>" : " />")
    end
  end
end
