module SinatraMore
  module JqueryScriptGen

    def setup_script
      script_download_path = "http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js"
      get(script_download_path, "public/javascripts/jquery.min.js")
    end
    
  end
end