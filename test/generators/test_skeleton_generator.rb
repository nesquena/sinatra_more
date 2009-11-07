require 'helper'
require 'thor'
require 'fakefs/safe'
require File.dirname(__FILE__) + "/../../generators/skeleton_generator"

class TestSkeletonGenerator < Test::Unit::TestCase
  context 'for the skeleton generator' do
    setup { `rm -rf /tmp/sample_app` }
    should "allow simple generator to run with no options" do
      assert_nothing_raised { silence_logger { SinatraMore::SkeletonGenerator.start(['sample_app', '/tmp']) } }
      assert File.exist?('/tmp/sample_app')
    end
    should "create components file containing options chosen with defaults" do
      silence_logger { SinatraMore::SkeletonGenerator.start(['sample_app', '/tmp']) }
      components_chosen = YAML.load_file('/tmp/sample_app/.components')
      assert_equal 'sequel', components_chosen[:orm]
      assert_equal 'bacon', components_chosen[:test]
      assert_equal 'rr', components_chosen[:mock]
      assert_equal 'jquery', components_chosen[:script]
      assert_equal 'haml', components_chosen[:renderer]
    end
    should "create components file containing options chosen" do
      component_options = ['--orm=datamapper', '--test=riot', '--mock=mocha', '--script=prototype', '--renderer=erb']
      silence_logger { SinatraMore::SkeletonGenerator.start(['sample_app', '/tmp', *component_options]) }
      components_chosen = YAML.load_file('/tmp/sample_app/.components')
      assert_equal 'datamapper', components_chosen[:orm]
      assert_equal 'riot',  components_chosen[:test]
      assert_equal 'mocha',     components_chosen[:mock]
      assert_equal 'prototype', components_chosen[:script]
      assert_equal 'erb',   components_chosen[:renderer]
    end
  end
end