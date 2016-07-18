require_relative 'node'
require_relative 'tnode'
require 'pry'
class DOMReader
  attr_reader :root, :num_nodes
  ATTRIBUTE_FINDER = / (.*?)="(.*?)"/
  ATTRIBUTE_FINDER2 = /<.*? .*?=".*?".*?>/
  FIND_NEXT_TAG = /<.*?>/
  TAG_TYPE_FINDER = /<.*?[ >]/
  OPEN_TAG_BOOL = /<[^\/].*?>/
  CLOSE_TAG_BOOL = /<[\/].*?>/

  def initialize(root = nil)
    raise error unless root.is_a?(Node) || root.nil?
    @stack = []
    @html = nil
    @index = 0
    @root = root
    @num_nodes = 1
  end

  def build_tree(file)
    @html = read_in_file(file) unless @html
    begin
      cur_node = get_next_tag
      @root = cur_node if @root.nil?
      handle_node(cur_node)
    end until @stack.empty? || (doctype?(@stack.last) && @num_nodes > 2)
    @root
  end

  def add_attributes(node)
    set_node_attributes(node) if tag_contains_attributes?(node.tag)
    node
  end

  def print_tree_nodes
    print_nodes
  end

  def print_nodes
    cur_node = @root
    children = []
    children.unshift( cur_node )
    until children.empty?
      cur_node.children.each do |child|
        children << child unless children.include?(child)
      end if cur_node.is_a?(Node) && cur_node.children.any?
      children.flatten!
      cur_node = children.shift
      p cur_node.is_a?(Node) ? cur_node.tag : cur_node.contents
    end
  end

  private

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
    @num_nodes += 1
    if doctype?(node)
      handle_doctype(node)
    elsif open_tag?(node.tag)
      handle_open_tag(node)
    else
      handle_close_tag(node)
    end
  end

  def handle_doctype(node)
    add_node_to_stack(node)
    set_index(node)
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

  def set_node_attributes(node)
    tag = node.tag
    while tag_contains_attributes?(tag)
      match = ATTRIBUTE_FINDER.match(tag)
      loc = (tag =~ ATTRIBUTE_FINDER) + match[0].length + 1
      attribute = match[1].strip.to_sym
      values = match[2].split(' ')
      values = values[0] if values.length == 1
      node.attributes[attribute] = values
      tag = "< #{tag[loc..-1]}"
    end
    node
  end

  def tag_contains_attributes?(tag)
    !!ATTRIBUTE_FINDER2.match(tag)
  end

  def add_node_to_stack(node)
    node.parent = @stack.last unless @stack.empty?
    @stack.last.children << node unless @stack.empty?
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

  def doctype?(node)
    node.tag.downcase == '<!doctype html>'
  end

  def close_tag?(html)
    !!(CLOSE_TAG_BOOL.match(html))
  end
end



