require './dom_reader'
require './node_renderer'
require './tree_searcher'

reader = DOMReader.new
tree = reader.build_tree('../test.html')

renderer = NodeRenderer.new(tree)
renderer.render(tree)

searcher = TreeSearcher.new(tree)
results = searcher.search_by(:id, "main-area")
results.each { |node| renderer.render(node) }

results = searcher.search_descendents(results[0], :class, "bold")
results.each { |node| renderer.render(node) }

results = searcher.search_ancestors(results[0], :id, "main-area")
results.each { |node| renderer.render(node) }
