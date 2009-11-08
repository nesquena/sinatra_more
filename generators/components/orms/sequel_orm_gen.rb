module SinatraMore
  module SequelOrmGen

    SEQUEL = <<-SEQUEL
module SequelInitializer
  def self.registered(app)
    app.configure do
      Sequel.connect(ENV['DATABASE_URL'])
    end
  end
end
SEQUEL

    USER = <<-USER
class User < Sequel::Model(:users)
  unless table_exists?
    set_schema do
      primary_key :id
      string :name
      string :username
      string :email
      string :crypted_password
    end
    create_table
  end
  
  def self.authenticate(username, password)
    user = User.filter(:username => username).first
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
      create_file(root_path("/config/initializers/sequel.rb"), SEQUEL)
      create_file(root_path("/app/models/user.rb"), USER)
      insert_require 'sequel', :path => root_path("/config/dependencies.rb"), :indent => 2
    end
  end
end
