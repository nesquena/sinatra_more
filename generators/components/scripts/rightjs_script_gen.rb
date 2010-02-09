module SinatraMore
  module RightjsScriptGen

    def setup_script
      copy_file("components/files/right-min.js", "public/javascripts/right-min.js")
      copy_file("components/files/right-olds-min.js", "public/javascripts/right-olds-min.js")
    end
    
  end
end