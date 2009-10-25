module SinatraMore
  module AssetTagHelpers
    # flash_tag(:notice)
    def flash_tag(kind, options={})
      flash_text = flash[kind]
      return '' if flash_text.blank?
      options.reverse_merge!(:class => 'flash')
      content_tag(:div, flash_text, options)
    end
    
    # name, url='javascript:void(0)', options={}, &block
    def link_to(*args, &block)
      if block_given?
        url, options = (args[0] || 'javascript:void(0);'), (args[1] || {})
        options.reverse_merge!(:href => url)
        link_content = capture_haml(&block)
        haml_concat(content_tag(:a, link_content, options))
      else
        name, url, options = args.first, (args[1] || 'javascript:void(0);'), (args[2] || {})
        options.reverse_merge!(:href => url)
        content_tag(:a, name, options)
      end
    end

    def image_tag(url, options={})
      options.reverse_merge!(:src => url)
      tag(:img, options)
    end

    def stylesheet_link_tag(*sources)
      options = sources.extract_options!.symbolize_keys
      sources.collect { |sheet| stylesheet_tag(sheet, options) }.join("\n")
    end

    def stylesheet_tag(source, options={})
      rel_path = "/stylesheets/#{source}.css?#{Time.now.to_i}"
      options = options.dup.reverse_merge!(:href => rel_path, :media => 'screen', :rel => 'stylesheet', :type => 'text/css')
      tag(:link, options)
    end

    def javascript_include_tag(*sources)
      options = sources.extract_options!.symbolize_keys
      sources.collect { |script| javascript_tag(script, options) }.join("\n")
    end

    def javascript_tag(source, options={})
      rel_path = "/javascripts/#{source}.js?#{Time.now.to_i}"
      options = options.dup.reverse_merge!(:content => "", :src => rel_path, :type => 'text/javascript')
      tag(:script, options)
    end
  end
end
