module SinatraMore
  module CouchrestOrmGen
    
    COUCHREST = <<-COUCHREST
module CouchRestInitializer
  def self.registered(app)
    app.configure(:development) { set :couchdb, CouchRest.database!('your_dev_db_here') }
    app.configure(:production)  { set :couchdb, CouchRest.database!('your_production_db_here') }
    app.configure(:test)        { set :couchdb, CouchRest.database!('your_test_db_here') }
  end
end
COUCHREST

  USER = <<-USER
class User < CouchRest::ExtendedDocument
  include CouchRest::Validation
  
  use_database app { couchdb }
  
  property :name
  property :username
  property :email
  property :crypted_password
  unique_id :id
  
  attr_accessor :password, :password_confirmation
  validates_is_confirmed :password
  
  save_callback :before, :encrypt_password
  
  def self.find(id)
    get(id)
  end
  
  def self.id_for(username)
    "user/\#{username}"
  end
  
  def self.authenticate(username, password)
    user = User.get(id_for(username))
    user && user.has_password?(password) ? user : nil
  end
  
  def id
    self.class.id_for(username)
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
      require_dependencies 'couchrest'
      create_file("config/initializers/couch_rest.rb", COUCHREST)
      create_file("app/models/user.rb", USER)
    end
  end
end