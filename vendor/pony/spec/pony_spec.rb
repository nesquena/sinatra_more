require File.dirname(__FILE__) + '/base'

describe Pony do
	it "sends mail" do
		Pony.should_receive(:transport) do |tmail|
			tmail.to.should == [ 'joe@example.com' ]
			tmail.from.should == [ 'sender@example.com' ]
			tmail.subject.should == 'hi'
			tmail.body.should == 'Hello, Joe.'
		end
		Pony.mail(:to => 'joe@example.com', :from => 'sender@example.com', :subject => 'hi', :body => 'Hello, Joe.')
	end

	it "requires :to param" do
		Pony.stub!(:transport)
		lambda { Pony.mail({}) }.should raise_error(ArgumentError)
	end

	it "doesn't require any other param" do
		Pony.stub!(:transport)
		lambda { Pony.mail(:to => 'joe@example.com') }.should_not raise_error
	end

	####################

	describe "builds a TMail object with field:" do
		it "to" do
			Pony.build_tmail(:to => 'joe@example.com').to.should == [ 'joe@example.com' ]
		end

		it "from" do
			Pony.build_tmail(:from => 'joe@example.com').from.should == [ 'joe@example.com' ]
		end

		it "from (default)" do
			Pony.build_tmail({}).from.should == [ 'pony@unknown' ]
		end

		it "subject" do
			Pony.build_tmail(:subject => 'hello').subject.should == 'hello'
		end

		it "body" do
			Pony.build_tmail(:body => 'What do you know, Joe?').body.should == 'What do you know, Joe?'
		end
		
		it "type" do
		  Pony.build_tmail(:type => 'html').content_type.should == 'text/html'
		end
		
		it "charset" do
		  Pony.build_tmail(:charset => 'windows-1252').charset.should == 'windows-1252'
		end
		
		it "attachments" do
			tmail = Pony.build_tmail(:attachments => {"foo.txt" => "content of foo.txt"})
			tmail.should have(1).parts
			tmail.parts.first.to_s.should == <<-PART
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=foo.txt

Y29udGVudCBvZiBmb28udHh0
			 PART
		end
	end

	describe "transport" do
		it "transports via the sendmail binary if it exists" do
			File.stub!(:executable?).and_return(true)
			Pony.should_receive(:transport_via_sendmail).with(:tmail)
			Pony.transport(:tmail)
		end

		it "transports via smtp if no sendmail binary" do
			Pony.stub!(:sendmail_binary).and_return('/does/not/exist')
			Pony.should_receive(:transport_via_smtp).with(:tmail)
			Pony.transport(:tmail)
		end

		it "transports mail via /usr/sbin/sendmail binary" do
			pipe = mock('sendmail pipe')
			IO.should_receive(:popen).with('-',"w+").and_yield(pipe)
			pipe.should_receive(:write).with('message')
			Pony.transport_via_sendmail(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'))
		end

		describe "SMTP transport" do
			before do
				@smtp = mock('net::smtp object')
				@smtp.stub!(:start)
				@smtp.stub!(:send_message)
				@smtp.stub!(:finish)
				Net::SMTP.stub!(:new).and_return(@smtp)
			end

			it "defaults to localhost as the SMTP server" do
				Net::SMTP.should_receive(:new).with('localhost', '25').and_return(@smtp)
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'))
			end

			it "uses SMTP authorization when auth key is provided" do
				o = { :smtp => { :user => 'user', :password => 'password', :auth => 'plain'}}
				@smtp.should_receive(:start).with('localhost.localdomain', 'user', 'password', 'plain')
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'), o)
			end

			it "enable starttls when tls option is true" do
				o = { :smtp => { :user => 'user', :password => 'password', :auth => 'plain', :tls => true}}
				@smtp.should_receive(:enable_starttls)
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'), o)
			end

			it "starts the job" do
				@smtp.should_receive(:start)
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'))
			end

			it "sends a tmail message" do
				@smtp.should_receive(:send_message)
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'))
			end

			it "finishes the job" do
				@smtp.should_receive(:finish)
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :from => 'from', :to_s => 'message'))
			end

		end
	end

	describe ":via option should over-ride the default transport mechanism" do
		it "should send via sendmail if :via => sendmail" do
			Pony.should_receive(:transport_via_sendmail)
			Pony.mail(:to => 'joe@example.com', :via => :sendmail)
		end

		it "should send via smtp if :via => smtp" do
			Pony.should_receive(:transport_via_smtp)
			Pony.mail(:to => 'joe@example.com', :via => :smtp)
		end

		it "should raise an error if via is neither smtp nor sendmail" do
			lambda { Pony.mail(:to => 'joe@plumber.com', :via => :pigeon) }.should raise_error(ArgumentError)
		end
	end

end
