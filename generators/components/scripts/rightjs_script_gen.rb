module SinatraMore
  module RightjsScriptGen

    def setup_script
      script_download_path = "http://rightjs.org/builds/current/right-min.js"
      get(script_download_path, "public/javascripts/right-min.js")
    end
    
  end
end