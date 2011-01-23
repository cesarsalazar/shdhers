require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/redirect_with_flash'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations' 
require 'dm-timestamps'
require 'dm-serializer/to_json'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/shdhers.sqlite3")

class User
  
  include DataMapper::Resource
  
  property :slug,         String,     :key => true
  
  validates_uniqueness_of :slug, :message => "There's already a user with this slug"
  
  property :first_name,       String,     :required => true
  property :last_name,        String,     :required => true
  property :email,            String,     :format => :email_address,  :unique => true    
  property :twitter,          String
  property :github,           String
  property :personal,         String
  property :expertise,        Object
  property :interests,        Object
  property :created_at,       DateTime
  property :updated_at,       DateTime

end

class Tag
	
  include DataMapper::Resource
	
	property :id,			Serial
	property :name, 	String, 	:required => true,	:unique => true
	
end

DataMapper.auto_upgrade!


# === Errors ===============================

not_found do
  haml :e404, :layout => false
end

# === Home ===============================

get '/' do 
  haml :index, :layout => false
end

# === Users ===============================

# Create
get '/new' do
  haml :new
end

post '/new' do
  @interests = params[:user][:interests] || []
  @expertise = params[:user][:expertise] || []
  @tags =  @interests + @expertise
	@tags.each do |t|
		@tag = Tag.first_or_create(:name => t)	
	end
  @user = User.new(params[:user])
  if @user.save
    redirect "/all" 
  else
    redirect "/new", :notice => 'Something went wrong'
  end
end


#Show all
get '/all' do
  @users = User.all(:order => [ :created_at.desc ])
  unless params[:format] == 'json'
    haml :list
  else
    content_type :json, 'charset' => 'utf-8'
    @users.to_json
  end
end


#Update
get '/:slug/edit' do
  @user = User.get(params[:slug])
  haml :edit
end

post '/:slug/edit' do
  @user = User.get(params[:slug])
  if @user.update(params[:user])
    redirect "/#{@user.username}/edit"
  else
    redirect "/#{@user.username}"
  end
end

#Exists
get '/:slug/exists' do
  @user = User.get(params[:slug])
  if @user.nil?
    {:slug => -1}.to_json
  else
    @user.to_json(:only => [:slug])
  end
end

#Delete
post '/:slug/delete' do
  @user = User.get(params[:slug])
  if @user.destroy
    redirect "/list"
  else
    redirect "/#{@user.username}"
  end  
end

#Show single
get '/:slug' do
  if @user = User.get(params[:slug])
    unless params[:format] == 'json'
      haml :show
    else
      content_type :json, 'charset' => 'utf-8'
      @user.to_json
    end
  else
    halt 404
  end
end

# === Tags ===============================

get '/tags/all' do
	@tags = Tag.all
	content_type :json
	@tags.to_json(:only => [:name])
end
	
post '/tags/new' do
	@tags = params[:tags]
	@tags.each do |t|
		@tag = Tag.first_or_create(:name => t)	
	end
	redirect '/'
end

get '/tags/:t' do
  @users = User.all(:interests => params[:t])
  haml :tag
end

# === Styles ===============================

get '/stylesheets/*' do
  content_type 'text/css'
  sass '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym
end