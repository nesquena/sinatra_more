require 'test_markup_plugin' unless defined?(TestMarkupPlugin)

class TestTagHelpers < TestMarkupPlugin  
  context 'for #tag method' do
    should("support tags with no content no attributes") do
       assert_equal '<br />', tag(:br) 
    end
    should("support tags with no content with attributes") do
      assert_equal '<br class="yellow" style="clear:both" />', tag(:br, :style => 'clear:both', :class => 'yellow')
    end
    should "support tags with content no attributes" do
      assert_equal '<p>Demo String</p>', tag(:p, :content => "Demo String")
    end
    should "support tags with content and attributes" do
      assert_equal '<p class="large" id="intro">Demo</p>', tag(:p, :content => "Demo", :class => 'large', :id => 'intro')
    end
  end
  
  context 'for #content_tag method' do
    should "support tags with content as parameter" do
      assert_equal '<p class="large" id="intro">Demo</p>', content_tag(:p, "Demo", :class => 'large', :id => 'intro')
    end
    should "support tags with content as block" do
      assert_equal '<p class="large" id="intro">Demo</p>', content_tag(:p, :class => 'large', :id => 'intro') { "Demo" }
    end
    should "support tags with erb" do
      visit '/erb/content_tag'
      assert_have_selector :p, :content => "Test 1", :class => 'test', :id => 'test1'
      assert_have_selector :p, :content => "Test 2"
      # TODO get these to work in erb
      # assert_have_selector :p, :content => "Test 3" 
      # assert_have_selector :p, :content => "Test 4"
    end
    should "support tags with haml" do
      visit '/haml/content_tag'
      assert_have_selector :p, :content => "Test 1", :class => 'test', :id => 'test1'
      assert_have_selector :p, :content => "Test 2"
      assert_have_selector :p, :content => "Test 3", :class => 'test', :id => 'test3'
      assert_have_selector :p, :content => "Test 4"
    end
  end
  
  context 'for #input_tag method' do
    should "support field with type" do
      assert_equal '<input type="text" />', input_tag(:text)
    end
    should "support field with type and options" do
      assert_equal '<input class="first" id="texter" type="text" />', input_tag(:text, :class => "first", :id => 'texter')
    end
  end
  
end