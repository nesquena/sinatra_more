module SinatraMore
  module TagHelpers
    # input_tag :text, :class => "test"
    def input_tag(type, options = {})
      options.reverse_merge!(:type => type)
      tag(:input, options)
    end

    # content_block_tag(:p, :class => 'dark') do ... end
    def content_block_tag(name, options={}, &block)
      options.merge!(:content => capture_html(&block))
      tag(name, options)
    end

    # content_tag(:p, "hello", :class => 'light')
    def content_tag(name, content, options={})
      tag(name, options.merge(:content => content))
    end

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
