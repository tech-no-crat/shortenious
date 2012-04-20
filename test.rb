ENV['RACK_ENV'] = 'test'

require 'rubygems'
require './shortenious.rb'
require 'test/unit'
require 'rack/test'
require 'mock_redis'


class ResponsivenessTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_home_page_responds
    get '/'
    assert last_response.ok?
  end
  
  def test_home_page_says_shortenious
    get '/'
    assert last_response.body.include? 'Shortenious'
  end
end

class ApplicationTest < Test::Unit::TestCase
  
end
