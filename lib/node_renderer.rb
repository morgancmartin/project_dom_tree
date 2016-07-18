class NodeRenderer
  TAG_TYPE_FINDER = /<.*?[ >]/
  INDENT = 2
  def initialize(tree)
    @tree = tree
    @level = 0
    @output = ''
  end

  def render(node)
    puts '******'
    print_tree(node)
    puts '******'
    @level = 0
  end

  def output_tree(filepath)
    @level = 0
    stringify_node(@tree)
    File.open(filepath, 'w').write(@output)
  end

  def stringify_tree(node)
    node.is_a?(Node) ? stringify_node(node) : stringify_text_node(node)
  end

  def stringify_node(node)
    @output += formatted_tag(node.tag) + "\n"
    @level += 1 unless doctype?(node)
    node.children.each { |child| stringify_tree(child) }
    @level -= 1 unless doctype?(node)
    @output += formatted_tag(matching_closing_tag(node.tag)) + "\n" unless doctype?(node)
  end

  def stringify_text_node(node)
    @output += formatted_tag(node.contents) + "\n"
  end

  def print_tree(node)
    node.is_a?(Node) ? print_node(node) : print_text_node(node)
  end

  def print_node(node)
    puts formatted_tag(node.tag)
    @level += 1 unless doctype?(node)
    node.children.each { |child| print_tree(child) }
    @level -= 1 unless doctype?(node)
    puts formatted_tag(matching_closing_tag(node.tag)) unless doctype?(node)
  end

  def doctype?(node)
    node.tag.downcase == '<!doctype html>'
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
