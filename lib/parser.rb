Node = Struct.new(:name, :attributes, :children)
TNode = Struct.new(:contents)

Tag = Struct.new(:type, :index)

class HTMLParser

  def initialize(html)
    @stack = []
    @html = html
  end

  def fill_stack
    until @html.empty?
      cur_tag = find_next_tag(@html)
      last_tag = @stack.last
      if @stack.length > 1 && (cur_tag.index - last_tag.index > 1)
        contents = @html[last_tag.index..cur_tag.index - 1]
        @stack << TNode.new(contents)
      end
      @stack << cur_tag
      new_index = cur_tag.index + cur_tag.type.length
      @html = @html[new_index..-1]
    end
  end

  def print_stack
    @stack.each do |val|
      p val
    end
  end

  def print_stack_values
    @stack.each do |val|
      if val.is_a?(Tag)
        puts "#{val.type}"
      elsif val.is_a?(TNode)
        puts "#{val.contents}"
      end
    end
  end

  def find_next_tag(html)
    match = /<.*?>/.match(html)
    loc = html =~ /<.*?>/
    Tag.new(match[0], loc)
  end


  def handle_tag_node
    open_tag = matching_tag(@cur_tag)
    if @stack.include?(open_tag)
      @stack.reverse.find_index(open_tag)
    end
  end

  def matching_tag(tag)
    chars = tag.chars
    chars.delete_at(1)
    chars.join('')
  end

  def handle_text_node
    cti = @cur_tag.index
    sli = @stack.last.index
    dif = cti - sli
    if dif > 1
      @stack << make_t_node(@html[cti, sli])
    end
  end

  def make_t_node(text)
    TNode.new(text)
  end

  def contains_html?(html)
    !!find_next_tag_contents(html)
  end


  def open_tag?(html)
    !!(/<[^\/].*?>/.match(html))
  end

  def close_tag?(html)
    !!(/<[\/].*?>/.match(html))
  end

  def find_next_tag_contents(html)
    match = /<.*?>(.*?)<\/.*?>/.match(html)
    match ? match[1] : false
  end

  def test_html
    "<h1>This is my <a>header link</a></h1>"
  end
end



class TagParser

  def parse_tag(tag)

  end
end
