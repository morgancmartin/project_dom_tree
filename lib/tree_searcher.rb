class TreeSearcher
  def initialize(tree)
    @tree = tree
  end

  def search_by(attribute, value)
    find_attribute(@tree, attribute, value)
  end

  def find_attribute(node, attribute, value)
    matches = []
    matches << node if node_has_attribute(node, attribute, value)
    node.children.each do |child|
      if child.is_a?(Node)
        child_matches = find_attribute(child, attribute, value)
        matches << child_matches if child_matches.any?
      end
    end if node.children.any?
    matches.flatten
  end

  def search_descendants(node, attribute, value)
    matches = []
    node.children.each do |child|
      if child.is_a?(Node)
        child_matches = find_attribute(child, attribute, value)
        matches << child_matches if child_matches.any?
      end
    end if node.children.any?
    matches.flatten
  end

  def search_ancestors(node, attribute, value)
    matches = []
    cur_node = node.parent
    until cur_node.nil?
      matches << cur_node if node_has_attribute(cur_node, attribute, value)
      cur_node = cur_node.parent
    end
    matches
  end

  private

  def node_has_attribute(node, attribute, value)
    return false unless node.is_a?(Node)
    values = node.attributes[attribute.to_sym]
    values.is_a?(Array) ? values.include?(value) : values == value
  end
end
