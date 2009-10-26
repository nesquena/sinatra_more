require 'helper'
require 'fixtures/markup_app/app'

class TestOutputHelpers < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  context 'for #capture_html method' do
    should "work for erb templates" do
      visit '/erb/capture_concat'
      assert_have_selector 'p span', :content => "Captured Line 1"
      assert_have_selector 'p span', :content => "Captured Line 2"
    end

    should "work for haml templates" do
      visit '/haml/capture_concat'
      assert_have_selector 'p span', :content => "Captured Line 1"
      assert_have_selector 'p span', :content => "Captured Line 2"
    end
  end

  context 'for #concat_content method' do
    should "work for erb templates" do
      visit '/erb/capture_concat'
      assert_have_selector 'p', :content => "Concat Line 3", :count => 1
    end

    should "work for haml templates" do
      visit '/haml/capture_concat'
      assert_have_selector 'p', :content => "Concat Line 3", :count => 1
    end
  end

  context 'for #block_is_template?' do
    should "work for erb templates" do
      visit '/erb/capture_concat'
      # TODO Get ERB template detection working
      # assert_have_selector 'p', :content => "The erb block passed in is a template", :class => 'is_template'
      assert_have_no_selector 'p', :content => "The ruby block passed in is a template", :class => 'is_template'
    end

    should "work for haml templates" do
      visit '/haml/capture_concat'
      assert_have_selector 'p', :content => "The haml block passed in is a template", :class => 'is_template'
      assert_have_no_selector 'p', :content => "The ruby block passed in is a template", :class => 'is_template'
    end
  end
end
