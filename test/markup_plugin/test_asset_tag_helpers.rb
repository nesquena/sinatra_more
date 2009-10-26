require 'test_markup_plugin' unless defined?(TestMarkupPlugin)

class TestAssetTagHelpers < TestMarkupPlugin
  include SinatraMore::AssetTagHelpers
  
  def flash
    { :notice => "Demo notice" }    
  end
  
  context 'for #flash_tag method' do
    should "display flash with no given attributes" do
      assert_equal '<div class="flash">Demo notice</div>', flash_tag(:notice)
    end
    should "display flash with given attributes" do
      flash_expected = '<div class="notice" id="notice-area">Demo notice</div>'
      assert_equal flash_expected, flash_tag(:notice, :class => 'notice', :id => 'notice-area')
    end
  end
  
  context 'for #link_to method' do
    should "display link element with no given attributes" do
      assert_equal '<a href="/register">Sign up</a>', link_to('Sign up', '/register')
    end
    should "display link element with given attributes" do
      link_expected = '<a class="first" href="/register" id="linky">Sign up</a>'
      assert_equal link_expected, link_to('Sign up', '/register', :class => 'first', :id => 'linky')
    end
    should "display link element with ruby block" do
      link_expected = '<a class="first" href="/register" id="binky">Sign up</a>'
      actual_link = link_to('/register', :class => 'first', :id => 'binky') do
        "Sign up"
      end
      assert_equal link_expected, actual_link
    end
    should "display link block element in haml" do
      visit '/haml/link_to'
      assert_have_selector :a, :content => "Test 1 No Block", :href => '/test1', :class => 'test', :id => 'test1'
      assert_have_selector :a, :content => "Test 2 With Block", :href => '/test2', :class => 'test', :id => 'test2'
    end
    should "display link block element in erb" do
      visit '/erb/link_to'
      assert_have_selector :a, :content => "Test 1 No Block", :href => '/test1', :class => 'test', :id => 'test1'
      #TODO fix this selector below in erb
      # assert_have_selector :a, :content => "Test 2 With Block", :href => '/test2', :class => 'test', :id => 'test2'
    end
  end
  
  context 'for #image_tag method' do
    should "display image tag absolute link with no options" do
      assert_equal '<img src="/absolute/pic.gif" />', image_tag('/absolute/pic.gif')
    end
    should "display image tag relative link with options" do
      assert_equal '<img class="photo" src="/images/relative/pic.gif" />', image_tag('relative/pic.gif', :class => 'photo')
    end
    should "display image tag relative link with incorrect space" do
      assert_equal '<img class="photo" src="/images/relative/pic.gif" />', image_tag(' relative/ pic.gif  ', :class => 'photo')
    end
  end
  
  context 'for #stylesheet_link_tag method' do
    should "display stylesheet link item" do
      time = stop_time_for_test
      expected_style = %Q[<link href="/stylesheets/style.css?#{time.to_i}" media="screen" rel="stylesheet" type="text/css" />]
      assert_equal expected_style, stylesheet_link_tag('style')
    end
    should "display stylesheet link items" do
      time = stop_time_for_test
      expected_style =  %Q[<link href="/stylesheets/style.css?#{time.to_i}" media="screen" rel="stylesheet" type="text/css" />\n]
      expected_style << %Q[<link href="/stylesheets/layout.css?#{time.to_i}" media="screen" rel="stylesheet" type="text/css" />\n]
      expected_style << %Q[<link href="http://google.com/style.css" media="screen" rel="stylesheet" type="text/css" />]
      assert_equal expected_style, stylesheet_link_tag('style', 'layout.css', 'http://google.com/style.css')
    end
  end
  
  context 'for #javascript_include_tag method' do
    should "display javascript item" do
      time = stop_time_for_test
      expected_include = %Q[<script src="/javascripts/application.js?#{time.to_i}" type="text/javascript"></script>]
      assert_equal expected_include, javascript_include_tag('application')
    end
    should "display javascript items" do
      time = stop_time_for_test
      expected_include = %Q[<script src="/javascripts/application.js?#{time.to_i}" type="text/javascript"></script>\n]
      expected_include << %Q[<script src="/javascripts/base.js?#{time.to_i}" type="text/javascript"></script>\n]
      expected_include << %Q[<script src="http://google.com/lib.js" type="text/javascript"></script>]
      assert_equal expected_include, javascript_include_tag('application', 'base.js', 'http://google.com/lib.js')
    end
  end
end