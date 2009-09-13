require 'rubygems'
require 'sinatra'

require 'lib/todo'

helpers do
  def all_priorities
    Todo.priorities
  end

  def link_to_priority(priority)
    "<a href='/priority/#{priority}'>#{priority}</a>"
  end

  def all_tags
    Todo.tags
  end

  def link_to_tag(tag)
    "<a href='/tagged/#{tag}'>##{tag}</a>"
  end
end

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
