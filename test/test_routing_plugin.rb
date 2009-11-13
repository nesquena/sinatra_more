require 'helper'
require 'fixtures/routing_app/app'

class TestRoutingPlugin < Test::Unit::TestCase
  def app
    RoutingDemo.tap { |app| app.set :environment, :test }
  end

  context 'for links list displaying routes' do
    setup { visit '/links' }
    should 'display route for account url' do
      assert_have_selector :p, :class => 'account_url', :content => '/the/accounts/foobar/path/10/end'
      assert_have_selector :p, :class => 'accounts_index', :content => '/the/accounts/index'
      assert_have_selector :p, :class => 'admin_url', :content => '/admin/25/show'
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
      "admin show for 50"
    end
  end
end
