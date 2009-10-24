module SinatraMore
  module TagHelpers
    # input_tag :text, :class => "test"
    def input_tag(type, options = {})
      options.reverse_merge!(:type => type)
      tag(:input, options)
    end

    def content_block_tag(name, options={}, &block)
      # TODO make this work with erb!!
      options.merge!(:content => block.call)
      tag(name, options)
    end

    def content_tag(name, content, options={})
      tag(name, options.merge(:content => content))
    end

    def tag(name, options={})
      content = options.delete(:content)
      html_attrs = options.collect { |a, v| v.blank? ? nil : "#{a}=\"#{v}\"" }.compact.join(" ")
      base_tag = (html_attrs.present? ? "<#{name} #{html_attrs}" : "<#{name}")
      base_tag << (content ? ">#{content}</#{name}>" : " />")
    end
  end
end
