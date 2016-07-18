require 'spec_helper'
require 'dom_reader'
require 'node_renderer'


describe NodeRenderer do

  let(:bodynode) { Node.new( '<body id="main-content">', 0, {}, [], nil) }
  let(:domreader) { DOMReader.new }
  let(:noderenderer) { NodeRenderer.new(domreader) }
  let(:prepopulated_renderer) { NodeRenderer.new(domreader) }




  # ----------------------------------------
  # #initialize
  # ----------------------------------------

  describe '#initialize' do
    before do
      domreader.build_tree('test.html')
    end

    it 'returns an instance of NodeRenderer' do
      expect(noderenderer).to be_an_instance_of(NodeRenderer)
    end


    it 'takes a tree as a parameter' do
      expect { prepopulated_renderer }.to_not raise_error
    end

  end


  # ----------------------------------------
  # #matching_closing_tag
  # ----------------------------------------

  describe '#matching_closing_tag' do

    it 'returns a string' do
      expect(noderenderer.matching_closing_tag('<html>')).to be_an_instance_of(String)
    end

    it 'returns a closing tag to an opening tag' do
      expect(noderenderer.matching_closing_tag('<html>')).to eq('</html>')
    end
  end
end
