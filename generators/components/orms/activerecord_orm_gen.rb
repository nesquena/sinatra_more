module SinatraMore
  module ActiverecordOrmGen
    
    AR = <<-AR
module ActiveRecordInitializer
  def self.registered(app)
    app.configure do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :dbfile =>  ENV['DATABASE_URL']
      )
    end
  end
end
AR


   MIGRATION = <<-MIGRATION
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
       t.column :name, :string
       t.column :username, :string
       t.column :email, :string
       t.column :crypted_password, :string
       t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
MIGRATION

  USER = <<-USER
class User < ActiveRecord::Base  
  def self.authenticate(username, password)
    user = User.first(:conditions => { :username => username })
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
      create_file(root_path("/config/initializers/activerecord.rb"), AR)
      create_file(root_path("/db/migrate/001_create_users.rb"), MIGRATION)
      create_file(root_path("/app/models/user.rb"), USER)
      insert_require 'active_record', :path => root_path("/config/dependencies.rb"), :space => 2
    end
  end
end