module SinatraMore
  module PrototypeScriptGen

    def setup_script
      script_download_path = "http://prototypejs.org/assets/2009/8/31/prototype.js"
      get(script_download_path, "public/javascripts/prototype.js")
    end
    
  end
end