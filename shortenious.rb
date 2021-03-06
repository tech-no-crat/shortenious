require "bundler/setup"
require "sinatra"

set :haml, :format => :html5

configure do
  require 'redis'
  require 'haml'
  require 'coffee_script'
  require 'sass'

  puts ENV["REDISTOGO_URL"]
  unless (not ENV["REDISTOGO_URL"]) or ENV["REDISTOGO_URL"].empty?
    uri = URI.parse(ENV["REDISTOGO_URL"])
    REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  else
    REDIS= Redis.new
  end

  DOMAIN = "shortenious.chrisp.gr"
end


def save(id, link)
  blacklist = ["stylesheets", "javascripts", "about", "contact", "api"]
  if (id =~ /^[a-zA-Z0-9\-_]*$/).nil? or id.length<3
    "Error: invalid id"
  elsif link.length < 3 or blacklist.include? link or not link =~ %r{\Ahttps?://}
    "Error: invalid link"
  else 
    # id/link are valid
    if REDIS.get(id).nil?
      if (REDIS.set id, link) == "OK"
        "OK: #{DOMAIN}/#{id}"
      else
        "Error: Unknown database error"
      end
    else
      "Error: id already in use"
    end
  end
end

get "/" do
  haml :new
end

get "/api" do
  haml :api
end

get "/:id" do |id|
  link = REDIS.get(id)
  noredirect = params[:noredirect] == true
  if link
    if noredirect
      link
    else
      redirect link
    end
  else
    "Error: id not found"
  end
end

post "/" do
  id = params[:id]
  link = params[:link]
  redirect = params[:redirect]=="true"
  
  save(id, link)
end


get "/stylesheets/style.css" do
  content_type "text/css"
  scss :style
end

get "/javascripts/app.js" do
  content_type "text/javascript"
  coffee :app
end
