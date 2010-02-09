module SinatraMore
  module PrototypeScriptGen

    def setup_script
      copy_file("components/files/prototype.js", "public/javascripts/prototype.js")
      copy_file('components/files/lowpro.js', "public/javascripts/lowpro.js")
    end
    
  end
end