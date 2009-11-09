module SinatraMore
  module DatamapperOrmGen
    
    DM = <<-DM
module DatamapperInitializer
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
  property :crypted_password, String

  def self.authenticate(username, password)
    user = User.first(:username => username)
    user && user.has_password?(password) ? user : nil
  end
  
  def encrypt_password
    self.crypted_password = BCrypt::Password.create(password)
  end
  
  def has_password?(password)
    BCrypt::Password.new(crypted_password) == password
  end
end
  USER
    
    def setup_orm
      insert_require 'dm-core', :path => "config/dependencies.rb", :indent => 2
      create_file("config/initializers/datamapper.rb", DM)
      create_file("app/models/user.rb", USER)
    end
  end
end