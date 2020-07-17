require 'rspec'
require '../lib/main'

RSpec.describe Enumerable do
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

  describe '#my_each_with_index' do
    it 'should be return array equal to the original' do
      ary = %w[zero one two]
      expect(ary.my_each_with_index { |value, key| key.to_s + value }).to eql(ary)
    end

    it 'should be return range equal to the original' do
      raw_range = (1..5)
      expect(raw_range.my_each_with_index { |value| value }).to eql(raw_range)
    end

    it 'should be excute the given block code' do
      raw_ary = %w[one two three]
      cap = ''
      raw_ary.my_each_with_index do |item|
        cap = item.upcase
      end
      expect(cap).to eql(raw_ary.last.upcase)
    end

    it 'should work with range' do
      raw_ary = %w[one two three]
      last = 0
      raw_ary.my_each_with_index do |item, key|
        last = key
        item
      end
      expect(last).to eql(raw_ary.length - 1)
    end
  end
end
