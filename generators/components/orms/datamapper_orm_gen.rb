module SinatraMore
  module DatamapperOrmGen
    
    DM = <<-DM
module DatamapperInitializer
  require 'dm-core'
  def self.registered(app)
    app.configure do
      DataMapper.setup(:default, ENV['DATABASE_URL'])
    end
  end
end
DM

  USER = <<-USER
class User
  include DataMapper::Resource
  
  property :name,     String
  property :username, String
  property :email,    String
end
  USER
    
    def setup_orm
      create_file(root_path("/config/initializers/datamapper.rb"), DM)
      create_file(root_path("/app/models/user.rb"), USER)
    end
  end
end