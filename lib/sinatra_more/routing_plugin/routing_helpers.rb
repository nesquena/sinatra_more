module SinatraMore
  module RoutingHelpers
    # Used to retrieve the full url for a given named route alias from the named_paths data
    # Accepts parameters which will be substituted into the url if necessary
    # url_for(:accounts) => '/accounts'
    # url_for(:account, :id => 5) => '/account/5'
    # url_for(:admin, show, :id => 5, :name => "demo") => '/admin/path/5/demo'
    def url_for(*aliases)
      values = aliases.extract_options!
      mapped_url = self.class.named_paths[aliases] || self.class.named_paths[aliases.unshift(self.class.app_name)]
      raise SinatraMore::RouteNotFound.new("Route alias #{aliases.inspect} could not be mapped to a url!") unless mapped_url
      result_url = String.new(mapped_url)
      result_url.scan(%r{/?(:\S+?)(?:/|$)}).each do |placeholder|
        value_key = placeholder[0][1..-1].to_sym
        result_url.gsub!(Regexp.new(placeholder[0]), values[value_key].to_s)
      end
      result_url
    end
  end
end