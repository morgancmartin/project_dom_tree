Node = Struct.new(:tag, :index, :attributes, :children)

TNode = Struct.new(:contents, :depth, :parent)

class HTMLParser

  def initialize(html = nil)
    @stack = []
    @html = html
    @index = 0
    @root = nil
    @level = 0
  end

  def build_tree
    begin
      break unless cur_node = get_next_tag
      @root = cur_node if @root.nil?
      handle_node(cur_node)
    end until @stack.empty?
    @root
  end

  def handle_node(node)
    if open_tag?(node.tag)
      handle_open_tag(node)
    else
      handle_close_tag(node)
    end
  end

  def handle_close_tag(node)
    add_text_node(node.index - 1) if node.index > 1
    @stack.pop
    @index += node.tag.length + node.index
  end

  def handle_open_tag(node)
    add_text_node(node.index - 1) if node.index > 1
    add_attributes(node)
    add_node_to_stack(node)
    set_index(node)
  end

  def add_attributes(node)
    set_node_attributes(node) if tag_contains_attributes?(node.tag)
    node
  end

  def set_node_attributes(node)
    tag = node.tag
    while tag_contains_attributes?(tag)
      match = / (.*?)="(.*?)"/.match(tag)
      loc = (tag =~ / (.*?)="(.*?)"/) + match[0].length + 1
      attribute = match[1].strip.to_sym
      values = match[2].split(' ')
      values = values[0] if values.length == 1
      node.attributes[attribute] = match[2].split(' ')
      tag = "< #{tag[loc..-1]}"
    end
    node
  end

  def tag_contains_attributes?(tag)
    !!/<.*? .*?=".*?".*?>/.match(tag)
  end

  def add_node_to_stack(node)
    @stack.last.children << node unless @stack.empty?
    @stack << node
  end

  def set_index(node)
    @index += node.tag.length + node.index
  end

  def get_next_tag
    find_next_tag(@html[@index..-1])
  end

  def print_tree(node = @root)
    node.is_a?(Node) ? print_node(node) : print_text_node(node)
  end

  def print_node(node)
    puts formatted_tag(node.tag)
    @level += 1
    node.children.each { |child| print_tree(child) }
    @level -= 1
    puts formatted_tag(matching_closing_tag(node.tag))
  end

  def formatted_tag(tag)
    length = tag.length
    tag.rjust(length + (@level * 2))
  end

  def print_text_node(node)
    puts formatted_tag(node.contents)
  end

  def add_text_node(index)
    contents = @html[@index..(@index + index)].strip
    @stack.last.children << TNode.new(contents) unless contents.empty?
  end

  def load_test_html
    file = File.open('../test.html', 'r')
    string = file.read
    file.close
    @html = string
  end

  def print_stack_values
    return_string = ''
    @stack.each do |val|
      if val.is_a?(Tag)
        return_string << val.type
      elsif val.is_a?(TNode)
        return_string << val.contents
      end
    end
    puts return_string
  end

  def find_next_tag(html)
    match = /<.*?>/.match(html)
    loc = html =~ /<.*?>/
    Node.new(match[0], loc, {}, [])
  end

  def matching_closing_tag(tag)
    tag = /<.*?[ >]/.match(tag)[0].strip
    chars = tag.chars
    chars.insert(1, '/') #</a>
    chars << '>' unless chars.last == '>'
    chars.join('')
  end

  # Removes the slash from a closing tag...
  def matching_tag(tag)
    chars = tag.chars
    chars.delete_at(1)
    chars.join('')
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
