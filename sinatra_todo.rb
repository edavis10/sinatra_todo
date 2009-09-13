require 'rubygems'
require 'sinatra'

require 'lib/todo'

get '/' do
  @todos = Todo.active
  erb :index
end

# TODO: all
# TODO: by priority
# TODO: by tag
