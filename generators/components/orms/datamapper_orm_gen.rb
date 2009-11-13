module SinatraMore
  module DatamapperOrmGen
    
    DM = <<-DM
module DataMapperInitializer
  def self.registered(app)
    app.configure(:development) { DataMapper.setup(:default, 'your_dev_db_here') }
    app.configure(:production)  { DataMapper.setup(:default, 'your_production_db_here') }
    app.configure(:test)        { DataMapper.setup(:default, 'your_test_db_here') }
  end
end
DM

  USER = <<-USER
class User
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :username, String
  property :email,    String
  property :crypted_password, String

  attr_accessor :password, :password_confirmation
  
  before :save, :encrypt_password
  
  validates_present :password, :password_confirmation

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
User.auto_upgrade!
USER
    
    def setup_orm
      require_dependencies 'dm-core', 'dm-validations'
      create_file("config/initializers/data_mapper.rb", DM)
      create_file("app/models/user.rb", USER)
    end
  end
end