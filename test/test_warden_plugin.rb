require 'helper'
require 'fixtures/warden_app/app'

class TestWardenPlugin < Test::Unit::TestCase
  def app
    WardenDemo.tap { |app| app.set :environment, :test }
  end
  
  context 'for authenticate_user! helper' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/current_user'
    end
    should "return name of logged_in user" do
      assert_have_selector :h1, :content => "John"
    end
  end
  
  context 'for logout_user! helper' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/logout'
      visit '/current_user'
    end
    should "return name of logged_in user" do
      assert_have_selector :h2, :content => "Not logged in"
    end
  end
  
  context 'for logged_in? helper when logged in' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/logged_in'
    end
    should "be logged in" do
      assert_have_selector :h1, :content => 'logged_in? true'
    end
  end
  
  context 'for logged_in? helper when logged out' do
    setup do
      visit '/logged_in'
    end
    should "not be logged in" do
      assert_have_selector :h1, :content => 'logged_in? false'
    end
  end
  
  context 'for authenticated? helper when logged in' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/authenticated'
    end
    should "reveal authorized content" do
      assert_have_selector :p, :content => "Dashboard, You are logged in!"
    end
  end
  
  context 'for authenticated? helper when logged out' do
    setup do
      visit '/authenticated'
    end
    should "hide authorized content" do
      assert_have_no_selector :p, :content => "Dashboard, You are logged in!"
    end
  end
  
  context 'for unregistered? helper when logged in' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/unregistered'
    end
    should "hide unregistered content" do
      assert_have_no_selector :p, :content => "Dashboard, You are unregistered!"
    end
  end
  
  context 'for unregistered? helper when logged out' do
    setup do
      visit '/unregistered'
    end
    should "reveal unregistered content" do
      assert_have_selector :p, :content => "Dashboard, You are unregistered!"
    end
  end
  
  context 'for must_be_authorized! helper with valid login' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/must_be_authorized'
    end
    should "be able to view page" do
      assert_have_selector :h1, :content => "Valid Authorized Page"
    end
  end
  
  context 'for must_be_authorized! helper when not logged in' do
    setup do
      visit '/must_be_authorized'
    end
    should "be forced to login" do
      assert_have_selector :h1, :content => "Please login!"
    end
  end
end