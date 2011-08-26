module TodoHelper
  # Simple auto_link, not really safe at all...
  def auto_link(content)
    content.gsub(/(https?:\/\/\S*)/) do
      "<a href='#{$1}'>#{$1}</a>"
    end
  end

  def link_to_priority(priority)
    "<a class='priority' href='/priority/#{priority}'>#{priority}</a>"
  end

    def link_to_tag(tag)
    "<a href='/tagged/#{tag}'>##{tag}</a>"
  end

  def edit_link(todo)
    "<a class='edit' data-offline='online-only' href='/edit/#{todo.line_number}'>(edit)</a>"
  end

end
