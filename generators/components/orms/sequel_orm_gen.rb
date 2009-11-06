module SinatraMore
  module SequelOrmGen

    SEQUEL = <<-SEQUEL
module SequelInitializer
  require 'sequel'
  def self.registered(app)
    app.configure do
      Sequel.connect(ENV['DATABASE_URL'])
    end
  end
end
SEQUEL

    USER = <<-USER
class User < Sequel::Model(:schema)
  unless table_exists?
    set_schema do
      primary_key :id
      string :name
      string :username
      string :email
    end
    create_table
  end
  
  def self.authenticate(username, password)
    user = User.first(:conditions => { :username => username })
    user && user.has_password?(password) ? user : nil
  end
end
USER

    def setup_orm
      create_file(root_path("/config/initializers/sequel.rb"), SEQUEL)
      create_file(root_path("/app/models/user.rb"), USER)
    end
  end
end
