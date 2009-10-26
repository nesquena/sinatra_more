require 'helper'
require 'fixtures/markup_app/app'

class TestFormBuilder < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  # TODO Test the form builder methods
end
