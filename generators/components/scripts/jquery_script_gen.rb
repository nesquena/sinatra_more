module SinatraMore
  module JqueryScriptGen

    def setup_script
      copy_file("components/files/jquery-1.3.2.min.js", "public/javascripts/jquery.min.js")
    end
    
  end
end