require 'helper'
require 'fixtures/markup_app/app'

class TestFormHelpers < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  # Test the form helper methods
end
