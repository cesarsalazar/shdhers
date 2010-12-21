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
  
  property :username,         Text,     :key => true
  property :first_name,       Text,     :required => true
  property :last_name,        Text,     :required => true
  property :email,            Text,     :format => :email_address, :unique => true    
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

get '/new' do
  haml :new
end

post '/new' do
  @user = User.new( params[:user] )

  if @user.save
    redirect "/#{@user.username}" 
  else
    redirect "/new"
  end
end

get '/list' do
  @users = User.all
  haml :list
end

get '/:username/edit' do
  @user = User.get(params[:username])
  haml :edit
end

post '/:username/edit' do
  @user = User.first(params[:username])
  if @user.update(  :first_name => params[:first_name],
                    :last_name => params[:last_name],
                    :username => params[:username],
                    :email => params[:email],
                    :twitter => params[:twitter],
                    :github => params[:github],
                    :expertise => params[:expertise],
                    :interests => params[:interests] )
    redirect "/#{@user.username}/edit"
  else
    redirect "/#{@user.username}"
  end
end

post '/:username/delete' do
  @user = User.first(params[:username])
  if @user.destroy
    redirect "/list"
  else
    redirect "/#{@user.username}"
  end  
end


get '/stylesheets/global.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :global
end

get '/:username' do
  if @user = User.get(params[:username])
    haml :show
  else
    halt 404, "There's no user with such username"
  end
end
