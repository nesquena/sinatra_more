module SinatraMore
  module PrototypeScriptGen

    def build_script
      get("http://prototypejs.org/assets/2009/8/31/prototype.js",
        @root_path+"/public/javascripts/prototype.js")
    end
    
  end
end