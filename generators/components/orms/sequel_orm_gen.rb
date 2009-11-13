module SinatraMore
  module SequelOrmGen

    SEQUEL = <<-SEQUEL
module SequelInitializer
  def self.registered(app)
    Sequel::Model.plugin(:schema)
    app.configure(:development) { Sequel.connect('your_dev_db_here') }
    app.configure(:production)  { Sequel.connect('your_production_db_here') }
    app.configure(:test)        { Sequel.connect('your_test_db_here') }
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

      attr_accessor :password, :password_confirmation

      def self.authenticate(username, password)
        user = User.filter(:username => username).first
        user && user.has_password?(password) ? user : nil
      end

      def encrypt_password
        return if password.blank?
        self.crypted_password = BCrypt::Password.create(password)
      end

      def has_password?(password)
        BCrypt::Password.new(crypted_password) == password
      end

      def before_save
        encrypt_password
      end

      def validate
        errors.add :password, "must not be empty" if self.crypted_password.blank? && password.blank?
        errors.add :password, "must match password confirmation" unless password == password_confirmation
      end
    end
USER

    def setup_orm
      require_dependencies 'sequel'
      create_file("config/initializers/sequel.rb", SEQUEL)
      create_file("app/models/user.rb", USER)
    end
  end
end
