require 'helper'
require 'fixtures/render_app/app'

class TestRenderPlugin < Test::Unit::TestCase
  def app
    RenderDemo.tap { |app| app.set :environment, :test }
  end
  
  context 'for #haml_template method' do
    setup { visit '/render_haml' }
    should('render template properly') do
      assert_have_selector "h1", :content => "This is a haml template!"
    end
  end
  
   context 'for #erb_template method' do
    setup { visit '/render_erb' }
    should('render template properly') do
      assert_have_selector "h1", :content => "This is a erb template!"
    end
  end

end
