class Todo
  attr_accessor :content
  attr_accessor :priority
  attr_accessor :tags

  def active?
    !self.priority.match(/[0X]/)
  end
  
  def self.all
    todos = []
    read_from_disk.each do |line|
      todos << new_from_file_format(line)
    end
    todos
  end

  def self.active
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if todo.active?
    end
    todos
  end

  private

  def self.new_from_file_format(line)
    todo = Todo.new
    todo.content = line.chomp
    todo.priority = line[0,1]
    todo.tags = '' # TODO
    todo
  end

  def self.read_from_disk
    @file_content = File.readlines("/home/edavis/doc/T/Todo/Todo.todo")
  end
end
