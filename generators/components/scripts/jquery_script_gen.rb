module SinatraMore
  module JqueryScriptGen

    def setup_script
      get("http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js", "public/javascripts/jquery.min.js")
    end
    
  end
end