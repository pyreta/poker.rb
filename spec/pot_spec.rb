require "rspec"
require "pot"

pot = Pot.new

describe Card do
  describe '#initialize' do
    it 'defaults to empty' do
      expect(pot.money).to be(0)
    end
  end

  describe '#add' do
    it 'can have money added to it' do
      pot.add(40)
      expect(pot.money).to be(40)
    end
  end


  describe '#take' do
    context 'pot has more than amount to be taken' do
      it 'removes and returns amount to be taken' do
        expect(pot.take(25)).to be(25)
        expect(pot.money).to be(15)
      end
    end
    context 'pot has more than amount to be taken' do
      it 'can have money takeed to it' do
        expect(pot.take(20)).to be(15)
        expect(pot.money).to be(0)
      end
    end
  end

  describe '#redeem' do
    it 'removes and returns entire pot' do
      pot.add(400)
      expect(pot.redeem).to be(400)
      expect(pot.money).to be(0)
    end
  end

end
