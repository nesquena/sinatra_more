require 'helper'
require 'fixtures/markup_app/app'

class TestFormatHelpers < Test::Unit::TestCase
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  include SinatraMore::FormatHelpers

  context 'for #relative_time_ago method' do
    should "display today" do
      assert_equal 'today', relative_time_ago(Time.now)
    end
    should "display yesterday" do
      assert_equal 'yesterday', relative_time_ago(1.day.ago)
    end
    should "display tomorrow" do
      assert_equal 'tomorrow', relative_time_ago(1.day.from_now)
    end
    should "return future number of days" do
      assert_equal 'in 4 days', relative_time_ago(4.days.from_now)
    end
    should "return past days ago" do
      assert_equal '4 days ago', relative_time_ago(4.days.ago)
    end
    should "return formatted archived date" do
      assert_equal 100.days.ago.strftime('%A, %B %e'), relative_time_ago(100.days.ago)
    end
    should "return formatted archived year date" do
      assert_equal 500.days.ago.strftime('%A, %B %e, %Y'), relative_time_ago(500.days.ago)
    end
  end

  context 'for #escape_javascript method' do
    should "escape double quotes" do
      assert_equal "\"hello\"", escape_javascript('"hello"')
    end
    should "escape single quotes" do
      assert_equal "\"hello\"", escape_javascript("'hello'")
    end
    should "escape html tags and breaks" do
      assert_equal "\"\\n<p>hello<\\/p>\\n\"", escape_javascript("\n\r<p>hello</p>\r\n")
    end
  end
end
