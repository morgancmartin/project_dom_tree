require 'spec_helper'
require 'dom_reader'


describe DOMReader do

  let(:bodynode) { Node.new( '<body id="main-content">', 0, {}, [], nil) }
  let(:bodywattrs) { Node.new( '', 0, {id: 'main-content' }, [], nil) }
  let(:htmlnode) { Node.new( '<html>', 0, {}, [bodynode], nil)}

  let(:domreader) { DOMReader.new }
  let(:prepopulated_reader) { DOMReader.new(htmlnode)}




  # ----------------------------------------
  # #initialize
  # ----------------------------------------

  describe '#initialize' do

    it 'returns an instance of DOMReader' do
      expect(domreader).to be_an_instance_of(DOMReader)
    end


    it 'takes a node as a parameter' do
      expect { prepopulated_reader }.to_not raise_error
    end


    it 'creates a root node with a value of nil' do
      expect(domreader.root).to be_nil
    end
  end


  # ----------------------------------------
  # #build_tree
  # ----------------------------------------

  describe '#build_tree' do

    it 'returns an instance of Node' do
      expect(domreader.build_tree('test.html')).to be_an_instance_of(Node)
    end

    it 'does not break on simple tags' do
      expect(!!domreader.build_tree('test.html')).to be(true)
    end

    it 'handles simple nested tags' do
      expect(!!domreader.build_tree('test.html')).to be(true)
    end

    it 'can handle text before and after a nested tag' do
      expect(!!domreader.build_tree('test.html')).to be(true)
    end

    it 'has the correct number of total nodes' do
      domreader.build_tree('test.html')
      expect(domreader.num_nodes).to eq(51)
    end
  end

  # ----------------------------------------
  # #add_attributes
  # ----------------------------------------

  describe '#add_attributes' do
    it 'can handle tags with attributes' do
      domreader.add_attributes(bodynode)
      expect(bodynode.attributes).to eq(bodywattrs.attributes)
    end
  end
end
