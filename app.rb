require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations' 
require 'dm-timestamps'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/shdhers.sqlite3")

class User
  
  include DataMapper::Resource
  
  property :username,         String,     :key => true
  property :first_name,       String,     :required => true
  property :last_name,        String,     :required => true
  property :email,            String,     :format => :email_address,  :unique => true    
  property :twitter,          String
  property :github,           String
  property :expertise,        String
  property :interests,        String
  property :created_at,       DateTime
  property :created_at,       DateTime
  property :updated_at,       DateTime

end

DataMapper.auto_upgrade!


#Error handling
not_found do
  haml :e404
end


# Home
get '/' do
  haml :index
end


# Create
get '/new' do
  haml :new
end

post '/new' do
  @user = User.new(params[:user])
  if @user.save
    redirect "/#{@user.username}" 
  else
    redirect "/new"
  end
end


#Show all
get '/list' do
  @users = User.all
  haml :list
end


#Update
get '/:username/edit' do
  @user = User.get(params[:username])
  haml :edit
end

post '/:username/edit' do
  @user = User.first(params[:username])
  if @user.update( params[:user] )
    redirect "/#{@user.username}/edit"
  else
    redirect "/#{@user.username}"
  end
end


#Delete
post '/:username/delete' do
  @user = User.get(params[:username])
  if @user.destroy
    redirect "/list"
  else
    redirect "/#{@user.username}"
  end  
end


#Show single
get '/:username' do
  if @user = User.get(params[:username])
    haml :show
  else
    halt 404
  end
end


#Styles
get '/stylesheets/global.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :global
end
