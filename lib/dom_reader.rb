Node = Struct.new(:tag, :index, :attributes, :children, :parent)
TNode = Struct.new(:contents, :depth, :parent)

class DOMReader
  ATTRIBUTE_FINDER = / (.*?)="(.*?)"/
  ATTRIBUTE_FINDER2 = /<.*? .*?=".*?".*?>/
  FIND_NEXT_TAG = /<.*?>/
  TAG_TYPE_FINDER = /<.*?[ >]/
  OPEN_TAG_BOOL = /<[^\/].*?>/
  CLOSE_TAG_BOOL = /<[\/].*?>/

  def initialize
    @stack = []
    @html = nil
    @index = 0
    @root = nil
  end

  def build_tree(file)
    @html = read_in_file(file)
    begin
      cur_node = get_next_tag
      @root = cur_node if @root.nil?
      handle_node(cur_node)
    end until @stack.empty?
    @root
  end

  def read_in_file(filepath)
    file = File.open(filepath, 'r')
    string = file.read
    file.close
    string
  end

  def add_text_node(index)
    contents = @html[@index..(@index + index)].strip
    @stack.last.children << TNode.new(contents) unless contents.empty?
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
      match = ATTRIBUTE_FINDER.match(tag)
      loc = (tag =~ ATTRIBUTE_FINDER) + match[0].length + 1
      attribute = match[1].strip.to_sym
      values = match[2].split(' ')
      values = values[0] if values.length == 1
      node.attributes[attribute] = match[2].split(' ')
      tag = "< #{tag[loc..-1]}"
    end
    node
  end

  def tag_contains_attributes?(tag)
    !!ATTRIBUTE_FINDER2.match(tag)
  end

  def add_node_to_stack(node)
    @stack.last.children << node unless @stack.empty?
    node.parent = @stack.last unless @stack.empty?
    @stack << node
  end

  def set_index(node)
    @index += node.tag.length + node.index
  end

  def get_next_tag
    find_next_tag(@html[@index..-1])
  end

  def find_next_tag(html)
    match = FIND_NEXT_TAG.match(html)
    loc = html =~ FIND_NEXT_TAG
    Node.new(match[0], loc, {}, [], nil)
  end

  def matching_closing_tag(tag)
    tag = FIND_NEXT_TAG.match(tag)[0].strip
    chars = tag.chars
    chars.insert(1, '/') #</a>
    chars << '>' unless chars.last == '>'
    chars.join('')
  end

  def contains_html?(html)
    !!find_next_tag_contents(html)
  end

  def open_tag?(html)
    !!(OPEN_TAG_BOOL.match(html))
  end

  def close_tag?(html)
    !!(CLOSE_TAG_BOOL.match(html))
  end
end