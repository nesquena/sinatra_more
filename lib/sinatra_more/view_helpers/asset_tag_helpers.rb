module SinatraMore
  module AssetTagHelpers
    def link_to(name, url='javascript:void(0)', options={})
      options.reverse_merge!(:href => url)
      content_tag(:a, name, options)
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
