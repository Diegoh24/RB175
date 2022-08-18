require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @users = YAML.load_file("users.yaml")
end

helpers do
  def all_interests
    interests = @users.map { |names, data| data[:interests] }
    interests.reduce(0) { |count, interest| count + interest.size }
  end

  def other_users
    @users.select { |name,_| name != @name }.keys
  end
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :home
end

get "/:name" do
  @name = params[:name].to_sym
  @interests = @users[@name][:interests]
  @email = @users[@name][:email]

  erb :user
end