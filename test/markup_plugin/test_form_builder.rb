require 'helper'
require 'fixtures/markup_app/app'

class TestFormBuilder < Test::Unit::TestCase
  include SinatraMore::FormHelpers

  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  context 'for #form_for method' do
    should "display correct form html" do
      user = stub()
      actual_html = form_for(user, '/register', :id => 'register') { "Demo" }
      assert_has_tag('form', :action => '/register', :id => 'register', :content => "Demo") { actual_html }
    end
  end

  # ===========================
  # AbstractFormBuilder
  # ===========================

  context 'for #error_messages method' do

  end

  context 'for #text_field method' do

  end

  context 'for #text_area method' do

  end

  context 'for #password_field method' do

  end

  context 'for #file_field method' do

  end

  context 'for #submit method' do

  end

  # ===========================
  # StandardFormBuilder
  # ===========================

  context 'for #text_field_block method' do

  end

  context 'for #text_area_block method' do

  end

  context 'for #password_field_block method' do

  end

  context 'for #file_field_block method' do

  end

  context 'for #submit_block method' do

  end
end
