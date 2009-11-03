require 'sinatra/base'
require 'sinatra_more'
require 'haml'

class MailerDemo < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
    set :smtp_settings, {
      :host   => 'smtp.gmail.com',
      :port   => '587',
      :tls    => true,
      :user   => 'user',
      :pass   => 'pass',
      :auth   => :plain
   }
  end
  
  register SinatraMore::MailerPlugin
  
  class SampleMailer < SinatraMore::MailerBase    
    def birthday_message(name, age)
      subject "Happy Birthday!"
      to   'john@fake.com'
      from 'noreply@birthday.com'
      body 'name' => name, 'age' => age
      via  :smtp
    end
    
    def anniversary_message(names, years_married)
      subject "Happy anniversary!"
      to   'julie@fake.com'
      from 'noreply@anniversary.com'
      body 'names' => names, 'years_married' => years_married
      type 'html'
    end
  end
  
  post "/deliver/plain" do
    result = SampleMailer.deliver_birthday_message("Joey", 21)
    result ? "mail delivered" : 'mail not delivered'
  end
  
  post "/deliver/html" do
    result = SampleMailer.deliver_anniversary_message("Joey & Charlotte", 16)
    result ? "mail delivered" : 'mail not delivered'
  end
end

class MailerUser
  
end