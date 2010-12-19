require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'

require 'dm-core'
require 'dm-validations'
require 'dm-migrations' 
require 'dm-timestamps'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/customer-admin.sqlite3")

class User
  
  include DataMapper::Resource

  property :id,               Serial   
  property :first_name,       Text,    :required => true
  property :last_name,        Text,    :required => true
  property :username,         Text,    :key => true
  property :email,            Text    
  property :twitter,          Text
  property :github,           Text
  property :expertise,        Text
  property :interests,        Text
  property :created_at,       DateTime
  property :created_at,       DateTime
  property :updated_at,       DateTime

end

DataMapper.auto_upgrade!



get '/' do
  haml :index
end

get '/:username' do
  haml :show
end

get '/new' do
  haml :new
end

post '/new' do
  # Create new, then..
  redirect "/#{@user}"
end

get '/list' do
  haml :list
end

get '/:username/edit' do
  haml :edit
end

post '/:username/edit' do
  #Edit user, then..
  redirect "/#{@user}"
end

post '/:username/delete' do
  #Delete user
  redirect "/list"
end


get '/stylesheets/global.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :global
end
