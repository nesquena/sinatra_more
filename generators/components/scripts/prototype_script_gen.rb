module SinatraMore
  module PrototypeScriptGen

    def setup_script
      get("http://prototypejs.org/assets/2009/8/31/prototype.js", "public/javascripts/prototype.js")
      get('http://github.com/nesquena/lowpro/raw/master/dist/lowpro.js', "public/javascripts/lowpro.js")
    end
    
  end
end