module SinatraMore
  module MongomapperOrmGen
    
    MONGO = <<-MONGO
class MongoDBConnectionFailure < RuntimeError; end

module MongoDbInitializer
  def self.registered(app)
    app.configure :development do
      MongoMapper.connection = Mongo::Connection.new('localhost')
      MongoMapper.database = 'your_dev_db_here'
    end

    app.configure :production do
      MongoMapper.connection = Mongo::Connection.new('localhost')
      MongoMapper.database = 'your_production_db_here'
    end

    app.configure :test do
      MongoMapper.connection = Mongo::Connection.new('localhost')
      MongoMapper.database = 'your_test_db_here'
    end
  end
end
MONGO

   CONCERNED = <<-CONCERN
module MongoMapper
  module Document
    module ClassMethods
      # TODO find a cleaner way for it to know where to look for dependencies
      def concerned_with(*concerns)
        concerns.each { |concern| require_dependency "./app/models/\#{name.underscore}/\#{concern}" }
      end
    end
  end
end
CONCERN

  USER = <<-USER
class User
  include MongoMapper::Document
  concerned_with :authentications

  key :name, String, :required => true
  key :username, String, :required => true
  key :email, String, :required => true
  key :crypted_password, String, :required => true
end
USER

  AUTH = <<-AUTH
class User
  attr_accessor :password, :password_confirmation
  before_validation :password_checks
  validate :validate_password

  def password_checks
    if password_required?
      encrypt_password if password.present? && password == password_confirmation
    end
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def encrypt_password
    self.crypted_password = BCrypt::Password.create(password)
  end

  def has_password?(password)
    BCrypt::Password.new(crypted_password) == password
  end

  def encrypt_password
    return if password.blank?
    self.crypted_password = BCrypt::Password.create(password)
  end

  def validate_password
    errors.add :password, "must not be empty" if crypted_password.blank? && password.blank?
    errors.add :password, "must match password confirmation" unless password == password_confirmation
  end

  def self.authenticate(username, password)
    user = User.first(:conditions => { :username => username })
    user && user.has_password?(password) ? user : nil
  end
end
AUTH

    def setup_orm
      require_dependencies 'mongo_mapper'
      create_file("config/initializers/mongo_db.rb", MONGO)
      create_file("lib/ext/mongo_mapper.rb", CONCERNED)
      create_file("app/models/user.rb", USER)
      create_file("app/models/user/authentications.rb", AUTH)
    end
  end
end