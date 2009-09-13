require 'rubygems'
require 'sinatra'

require 'lib/todo'

get '/' do
  @todos = Todo.active
  erb :index
end

get '/priority/:priority' do
  @todos = Todo.find_by_priority(params[:priority])
  erb :index
end

# TODO: all
# TODO: by tag
