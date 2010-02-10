module SinatraMore
  module ActiverecordOrmGen
    
    AR = <<-AR
module ActiveRecordInitializer
  def self.registered(app)
    app.configure :development do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => ":memory:"
      )
    end

    app.configure :production do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => ":memory:"
      )
    end

    app.configure :test do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => ":memory:"
      )
    end
  end
end
AR

RAKE = <<-RAKE
require 'sinatra/base'
require 'active_record'

namespace :db do
  desc "Migrate the database"
  task(:migrate) do
    load 'config/boot.rb'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
RAKE


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
  before_save :encrypt_password
  
  attr_accessor :password, :password_confirmation
  
  def validate
    errors.add :password, "must not be empty" if self.crypted_password.blank? && password.blank?
    errors.add :password, "must match password confirmation" unless password == password_confirmation
  end
  
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
      require_dependencies 'activerecord'
      create_file("config/initializers/active_record.rb", AR)
      create_file("Rakefile", RAKE)
      create_file("db/migrate/001_create_users.rb", MIGRATION)
      create_file("app/models/user.rb", USER)
    end
  end
end