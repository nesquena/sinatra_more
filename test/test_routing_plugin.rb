require 'helper'
require 'fixtures/routing_app/app'

class TestRoutingPlugin < Test::Unit::TestCase
  def app
    RoutingDemo.tap { |app| app.set :environment, :test }
  end

  context 'for links list displaying routes' do
    setup { visit '/links' }
    should 'display account route links' do
      assert_have_selector :p, :class => 'account_url', :content => '/the/accounts/foobar/path/10/end'
      assert_have_selector :p, :class => 'accounts_index', :content => '/the/accounts/index'
    end
    should "display admin route links" do
      assert_have_selector :p, :class => 'admin_url', :content => '/admin/25/show'
      assert_have_selector :p, :class => 'admin_url2', :content => '/admin/10/update/test'
      assert_have_selector :p, :class => 'admin_url3', :content => '/admin/12/destroy'
    end
  end

  context 'for no namespaced account route' do
    setup { visit '/the/accounts/demo/path/5/end'}
    should "return proper account text" do
      assert_have_selector :h1, :content => "the account url for demo and id 5"
    end
  end

  context 'for no namespaced accounts index route' do
    setup { visit '/the/accounts/index/'}
    should "return proper account text" do
      assert_have_selector :h1, :content => "the accounts index"
    end
  end

  context 'for admin show url' do
    setup { visit '/admin/50/show' }
    should "return proper admin test" do
      assert_have_selector :p, :content => "admin show for id 50"
    end
  end
  
  context 'for admin update url' do
    setup { visit '/admin/15/update/demo' }
    should "return proper update text" do
      assert_have_selector :p, :content => "updated admin with id 15 and name demo"
    end
  end
  
  context 'for admin destroy url' do
    setup { visit '/admin/60/destroy' }
    should "return proper destroy text" do
      assert_have_selector :p, :content => "destroy admin with id 60"
    end
  end
end
