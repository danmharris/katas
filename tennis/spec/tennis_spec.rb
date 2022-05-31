# frozen_string_literal: true

require File.join(File.dirname(__FILE__), '../lib/tennis.rb')

describe 'Tennis' do
  let(:tennis) { Tennis.new('Alice', 'Bob') }

  describe 'setting up players' do
    it 'sets up with player names' do
      expect(tennis.players).to eq(%w[Alice Bob])
    end

    it 'gets their scores for player names' do
      expect(tennis.score('Alice')).to eq(0)
      expect(tennis.score('Bob')).to eq(0)
      expect { tennis.score('Fred') }.to raise_error(UnknownPlayerError)
    end
  end

  describe 'normal scoring' do
    it 'goes up to 40' do
      [15, 30, 40].each do |point|
        tennis.point('Alice')
        expect(tennis.score('Alice')).to eq(point)
      end
    end

    it 'marks as won once past 40' do
      3.times do
        tennis.point('Alice')
        expect(tennis.finished?).to be(false)
      end

      tennis.point('Alice')
      expect(tennis.finished?).to be(true)
      expect(tennis.winner).to eq('Alice')
    end
  end

  describe 'deuce' do
    before do
      3.times do
        tennis.point('Alice')
        tennis.point('Bob')
      end
    end

    it 'marks game as not deuce normally' do
      tennis = Tennis.new('Alice', 'Bob')
      expect(tennis.deuce?).to be(false)
    end

    it 'marks game as deuce if both on 40' do
      expect(tennis.deuce?).to be(true)
    end

    it 'puts score as advantage if point at deuce' do
      tennis.point('Alice')
      expect(tennis.score('Alice')).to eq(:advantage)
      expect(tennis.score('Bob')).to eq(40)
      expect(tennis.finished?).to be(false)
    end

    it 'puts goes back to deuce if non-advantage points' do
      tennis.point('Alice')
      tennis.point('Bob')
      expect(tennis.score('Alice')).to eq(40)
      expect(tennis.score('Bob')).to eq(40)
      expect(tennis.finished?).to be(false)
    end

    it 'game is won if scored on advantage' do
      tennis.point('Alice')
      tennis.point('Alice')
      expect(tennis.finished?).to be(true)
      expect(tennis.winner).to eq('Alice')
    end
  end
end
