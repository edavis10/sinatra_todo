require 'rubygems'
require 'sinatra'

require 'lib/todo'

TODO_FILE = ENV['TODO_FILE'] || ARGV[0] || './todo'

# Stupid simple auth
use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'todos'
end unless ENV['AUTH'] == "off"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def all_priorities
    Todo.priorities
  end

  def link_to_priority(priority)
    "<a class='priority' href='/priority/#{priority}'>#{priority}</a>"
  end

  def all_tags
    Todo.tags
  end

  def link_to_tag(tag)
    "<a href='/tagged/#{tag}'>##{tag}</a>"
  end

  def edit_link(todo)
    "<a class='edit' href='/edit/#{todo.line_number}'>(edit)</a>"
  end
end

get '/' do
  @todos = Todo.active
  erb :index
end

get '/all' do
  @todos = Todo.all
  @page_title = '- All'
  erb :index
end

get '/priority/:priority' do
  @todos = Todo.find_by_priority(params[:priority])
  @page_title = "- Priority: #{params[:priority]}"
  erb :index
end

get '/tagged/:tag' do
  @todos = Todo.find_by_tag(params[:tag])
  @page_title = "- Tagged: #{params[:tag]}"
  erb :index
end

get '/add' do
  if params.empty?
    @page_title = "- Add New Todo"
    erb :add
  else
    redirect '/', 303
  end
end

post '/add' do
  open(TODO_FILE,'a') { |f| f.puts(params[:todo]) }
  redirect '/', 303
end

get '/edit/:line' do
  @todo = Todo.find(params[:line])
  @page_title = "- Edit - #{@todo.content}"
  erb :edit
end

put '/update' do
  @todo = Todo.find(params[:line])
  @todo.update(params[:todo])
  redirect '/', 302
end

get '/cache.manifest' do
  content_type 'text/cache-manifest'
  @images = Dir['public/images/**'].collect {|name| name.sub(/^public/,'') }

  erb :cache_manifest, :layout => false
end

get '/offline' do
  'Resource is only available when online'
end
