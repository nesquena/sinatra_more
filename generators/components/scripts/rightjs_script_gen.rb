module SinatraMore
  module RightjsScriptGen

    def setup_script
      get("http://rightjs.org/builds/current/right-min.js",
        root_path("/public/javascripts/right-min.js"))
    end
    
  end
end