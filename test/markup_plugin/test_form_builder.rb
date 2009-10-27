require 'helper'
require 'fixtures/markup_app/app'

class TestFormBuilder < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  context 'for #form_for method' do
    
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
