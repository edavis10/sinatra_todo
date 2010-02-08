class Todo
  PriorityContentRegex = /^([\S.]) ([^#]*)/
  CompleteProirityRegex = /[0XC]/

  attr_accessor :content
  attr_accessor :priority
  attr_accessor :tags

  def active?
    self.priority && !self.priority.match(CompleteProirityRegex)
  end

  def has_tag?(tag)
    tags.include?(tag.downcase)
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

  def self.find_by_priority(priority)
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if priority == todo.priority
    end
    todos
  end
  
  def self.find_by_tag(tag)
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if todo.has_tag?(tag)
    end
    todos
  end

  def self.priorities
    priorities = []
    read_from_disk.each do |line|
      line =~ PriorityContentRegex
      priorities << $1.strip if $1
    end
    priorities.uniq.sort
  end

  def self.tags
    tags = []
    read_from_disk.each do |line|
      tags << Todo.find_tags(line.chomp)
    end
    tags.flatten.uniq.sort
  end

  private

  def self.find_tags(line)
    line.
      scan(/#[\w\-_]+/). # Hash words
      collect {|w| w.sub(/#/,'').downcase }. # Remove hash (#)
      uniq
  end
  
  def self.new_from_file_format(line)
    todo = Todo.new
    line =~ PriorityContentRegex
    todo.priority = $1.strip if $1
    todo.content = $2.strip if $2
    todo.tags = Todo.find_tags(line.chomp)
    todo
  end

  def self.read_from_disk
    @file_content = File.readlines(TODO_FILE)
  end
end
