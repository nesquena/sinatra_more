require 'helper'
require 'thor'
require File.dirname(__FILE__) + "/../generators/skeleton_generator"

class TestSinatraGenerator < Test::Unit::TestCase
  context 'for the skeleton generator' do
    should "yay" do
      SinatraMore::SkeletonGenerator.start
    end
  end
end