require 'rspec'
require '../lib/main'

RSpec.describe Enumerable do
  fruits_ary = %w[apple banana strawberry pineapple]

  describe '#my_each' do
    it 'should be equal' do
      expect(fruits_ary.my_each(&:upcase)).to eql(fruits_ary)
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
    it 'should return array equal to the original' do
      expect(fruits_ary.my_each_with_index { |value| value }).to eql(fruits_ary)
    end

    it 'should return range equal to the original' do
      raw_range = (1..5)
      expect(raw_range.my_each_with_index { |value| value }).to eql(raw_range)
    end

    it 'should be excute the given block code' do
      cap = ''
      fruits_ary.my_each_with_index do |item|
        cap = item.upcase
      end
      expect(cap).to eql(fruits_ary.last.upcase)
    end

    it 'should work with range' do
      last = 0
      fruits_ary.my_each_with_index do |item, key|
        last = key
        item
      end
      expect(last).to eql(fruits_ary.length - 1)
    end
  end

  describe '#my_select' do
    it 'should return filtered array based on the given block' do
      expect(fruits_ary.my_select { |value| value == 'banana' }).to eql(['banana'])
    end

    it 'should work with range' do
      filtered = (1..5).my_select do |value|
        value if value == 1
      end
      expect(filtered).to eql([1])
    end

    it 'should return Enumerable if the block is missing' do
      expect(fruits_ary.my_select.is_a?(Enumerable)).to eql(true)
    end
  end

  describe '#my_all?' do
    it 'should return false based on the given block' do
      expect(fruits_ary.my_all? { |value| value == 'banana' }).to eql(false)
    end

    it 'should work with range' do
      expect((1..5).my_all? { |val| val.is_a?(Numeric) }).to eql(true)
    end

    it 'should return false if the given array has a falsy data' do
      expect([nil, true, 99].my_all?).to eql(false)
    end

    it 'should return true no falsy data is provided' do
      expect([].my_all?).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'should return true based on the given block if it returns true' do
      expect(fruits_ary.my_any? { |value| value == 'banana' }).to eql(true)
    end

    it 'should work with range' do
      expect((1..5).my_any? { |val| val.is_a?(String) }).to eql(false)
    end

    it 'should return true if the given array has one truthy data' do
      expect([nil, true, 99].my_any?).to eql(true)
    end

    it 'should return true if the given type parameter match one of the element' do
      ary = fruits_ary + [2]
      expect(ary.my_any?(Numeric)).to eql(true)
    end

    it 'should return true if the given parameter match one of the element' do
      expect(fruits_ary.my_any?('banana')).to eql(true)
    end

    it 'should return fasle no truthy data is provided' do
      expect([].my_any?).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'should return false based on the given block ' do
      expect(fruits_ary.my_none? { |value| value == 'banana' }).to eql(false)
    end

    it 'should work with range' do
      expect((1..5).my_none? { |val| val.is_a?(String) }).to eql(true)
    end

    it 'should return true if the given array has no truthy data' do
      expect([nil, false].my_none?).to eql(true)
    end

    it 'should return true no truthy data is provided' do
      expect([].my_none?).to eql(true)
    end
  end

  describe '#my_count' do
    it 'should return the length of the array if no block given' do
      expect(fruits_ary.my_count).to eql(fruits_ary.length)
    end

    it 'should work with range' do
      expect((1..5).my_count).to eql(5)
    end

    it 'should return true if the given array has no truthy data' do
      expect(fruits_ary.my_count(100)).to eql(fruits_ary.count(100))
    end

    it 'should return true no truthy data is provided' do
      expect(fruits_ary.my_count { |item| item.eql?('banana') }).to eql(1)
    end
  end

  describe '#my_map' do
    it 'should return the filtered of the array based on the given block' do
      expect(fruits_ary.my_map { |item| item.length * 100 }).to eql(fruits_ary.map { |item| item.length * 100 })
    end

    it 'should work with range' do
      expect((1..5).my_map { |i| i * i }).to eql([1, 4, 9, 16, 25])
    end

    it 'should return Enumerable if the block is missing' do
      expect(fruits_ary.my_map.is_a?(Enumerable)).to eql(true)
    end
  end

  describe '#my_inject' do
    it 'should return the accumulated value' do
      ary = [5, 6, 7, 8, 9, 10]
      expect(ary.my_inject { |acc, n| acc + n }).to eql(45)
    end

    it 'should work with range' do
      expect((1..4).inject { |product, n| product * n }).to eql(24)
    end

    it 'should return the accumulated value based the given parameter' do
      expect((5..10).my_inject(100) { |acc, n| acc + n }).to eql(145)
    end

    it 'should return the accumulated value based the given wild card' do
      expect((1..4).my_inject(:+) { |acc, n| acc + n }).to eql(10)
    end

    it 'should return the accumulated value based the given wild card and initial value' do
      expect((1..4).my_inject(10, :*) { |acc, n| acc + n }).to eql(240)
    end

    it 'should return the longest word' do
      longest = %w[cat sheep bear].inject do |memo, word|
        memo.length > word.length ? memo : word
      end
      expect(longest).to eql('sheep')
    end

    it 'should return the longest wor' do
      votes = ["Hayat", "Sky Light", "Hayat"]
      result = votes.my_inject(Hash.new(0)) do |res, vote|
        res[vote] = res[vote] + 1
        res
      end
      expect(result['Hayat']).to eql(2)
    end
  end
end
