require 'spec_helper'
require 'dom_reader'
require 'tree_searcher'


describe TreeSearcher do

  let(:rootnode) { DOMReader.new.build_tree('test.html') }
  let(:searcher) { TreeSearcher.new(rootnode) }
  let(:innerdiv) { rootnode.children[1].children[0].children[1] }


  # ----------------------------------------
  # #initialize
  # ----------------------------------------

  describe '#initialize' do

    it 'takes a tree as a parameter' do
      expect { searcher }.to_not raise_error
    end

    it 'returns an instance of TreeSearcher' do
      expect(searcher).to be_an_instance_of(TreeSearcher)
    end
  end


  # ----------------------------------------
  # #search_by
  # ----------------------------------------

  describe '#search_by' do

    it 'can find an attribute anywhere in the tree' do
      expect(searcher.search_by('class', 'bold')[0]).to be_an_instance_of(Node)
    end
  end

  # ----------------------------------------
  # #search_descendants
  # ----------------------------------------

  describe '#search_descendants' do
    it 'can find an attribute in a nodes descendants' do
      expect(searcher.search_descendants(rootnode, 'class', 'bold')[0]).to be_an_instance_of(Node)
    end
  end

  # ----------------------------------------
  # #search_ancestors
  # ----------------------------------------

  describe '#search_ancestors' do
    it 'can find an attribute based on a nodes ancestors' do
      expect(searcher.search_ancestors(innerdiv, 'class', 'top-div')[0]).to eq(innerdiv.parent)
    end
  end
end
