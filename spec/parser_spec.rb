require 'parser'

describe HTMLParser do

  let(:html) { "<p>paragraph</p>"}

  describe '#contains_html?' do
    it 'returns true if it is provided html' do
      expect(subject.contains_html?(html)).to be(true)
    end

    it 'returns false if there is no html' do
      expect(subject.contains_html?('<i am not ht/ml>')).to be(false)
    end
  end


end
