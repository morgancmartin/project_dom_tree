class NodeRenderer
  TAG_TYPE_FINDER = /<.*?[ >]/
  INDENT = 2
  def initialize(tree)
    @tree = tree
    @level = 0
  end

  def render(node)
    puts '******'
    print_tree(node)
    puts '******'
    @level = 0
  end

  def print_tree(node)
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
    tag.rjust(length + (@level * INDENT))
  end

  def print_text_node(node)
    puts formatted_tag(node.contents)
  end

  def matching_closing_tag(tag)
    tag = TAG_TYPE_FINDER.match(tag)[0].strip
    chars = tag.chars
    chars.insert(1, '/') #</a>
    chars << '>' unless chars.last == '>'
    chars.join('')
  end
end
