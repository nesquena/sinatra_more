module SinatraMore
  module TagHelpers
    # input_tag :text, :class => "test"
    def input_tag(type, options = {})
      options.reverse_merge!(:type => type)
      tag(:input, options)
    end

    # content_tag(:p, "hello", :class => 'light')
    # content_tag(:p, :class => 'dark') do ... end
    # parameters: content_tag(name, content=nil, options={})
    # options = { :concat => true/false }
    def content_tag(*args, &block)
      name = args.first
      options = args.extract_options!
      options.reverse_merge!(:concat => true) if block_given?
      should_concat = options.delete(:concat)
      tag_html = block_given? ? capture_html(&block) : args[1]
      tag_result = tag(name, options.merge(:content => tag_html))
      should_concat ? concat_content(tag_result) : tag_result
    end
    alias content_block_tag content_tag

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
