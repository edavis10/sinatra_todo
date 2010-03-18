require 'tempfile'
require 'fileutils'

class Todo
  PriorityContentRegex = /^([\S.]) ([^#]*)/
  CompleteProirityRegex = /[0XC]/

  attr_accessor :content
  attr_accessor :priority
  attr_accessor :tags
  attr_accessor :line_number
  attr_accessor :raw_line

  def active?
    self.priority && !self.priority.match(CompleteProirityRegex)
  end

  def has_tag?(tag)
    tags.include?(tag.downcase)
  end

  def update(content)
    self.raw_line = content
    write_to_disk
  end
  
  def self.all
    todos = []
    read_from_disk.each_with_index do |line, line_number|
      todos << new_from_file_format(line, line_number)
    end
    todos
  end

  def self.active
    todos = []
    read_from_disk.each_with_index do |line, line_number|
      todo = new_from_file_format(line, line_number)
      todos << todo if todo.active?
    end
    todos
  end

  def self.find_by_priority(priority)
    todos = []
    read_from_disk.each_with_index do |line, line_number|
      todo = new_from_file_format(line, line_number)
      todos << todo if priority == todo.priority
    end
    todos
  end
  
  def self.find_by_tag(tag)
    todos = []
    read_from_disk.each_with_index do |line, line_number|
      todo = new_from_file_format(line, line_number)
      todos << todo if todo.has_tag?(tag)
    end
    todos
  end

  def self.find(line_number)
    line_contents = read_line_from_file(line_number)
    new_from_file_format(line_contents, line_number)
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
  
  def self.new_from_file_format(line, line_number)
    todo = Todo.new
    todo.raw_line = line
    line =~ PriorityContentRegex
    todo.priority = $1.strip if $1
    todo.content = $2.strip if $2
    todo.tags = Todo.find_tags(line.chomp)
    todo.line_number = line_number
    todo
  end

  def self.read_from_disk
    @file_content = File.readlines(TODO_FILE)
  end

  def self.read_line_from_file(line_number)
    File.open(TODO_FILE) do |file|
      file.each_with_index do |line, lineno|
        return line if lineno == line_number.to_i
      end
    end
    nil
  end

  def write_to_disk
    file_data = File.readlines(TODO_FILE)
    file_data[line_number.to_i] = raw_line + "\n"

    begin
      tmp = Tempfile.new("todo")
      tmp.write(file_data)
      tmp.rewind
      FileUtils.mv(tmp.path, TODO_FILE)
    ensure
      tmp.close if tmp
    end
  end
end
