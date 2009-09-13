require 'rubygems'
require 'sinatra'

require 'lib/todo'

get '/' do
  @todos = Todo.active
  erb :index
end

get '/all' do
  @todos = Todo.all
  erb :index
end

get '/priority/:priority' do
  @todos = Todo.find_by_priority(params[:priority])
  erb :index
end

get '/tagged/:tag' do
  @todos = Todo.find_by_tag(params[:tag])
  erb :index
end
