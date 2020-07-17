require 'rspec'
require '../lib/main'

Rspec.describe Enumerable do
  describe '#my_each' do
    it 'should be equal' do
      ary = %w[zero one two]
      expect(ary.my_each(&:upcase)).to eql(ary)
    end

    it 'should be excute the given block code' do
      raw_ary = %w[one two three]
      cap = ''
      raw_ary.my_each do |item|
        cap = item.upcase
      end
      expect(cap).to eql(raw_ary.last.upcase)
    end

    it 'should work with range' do
      raw_range = (1..5)
      last = 0
      raw_range.my_each do |item|
        last = item
      end
      expect(last).to eql(raw_range.last)
    end
  end
end
