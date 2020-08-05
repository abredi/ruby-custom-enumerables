require 'rspec'
require_relative '../lib/main'

RSpec.describe Enumerable do
  let(:fruits_ary) { %w[apple banana strawberry pineapple] }
  let(:raw_range) { (1..5) }
  let(:str_ary) { %w[Hayat Sky-Light Hayat] }
  let(:number_ary) { [5, 6, 7, 8, 9, 10] }

  context '#my_each' do
    it 'should return array equal to the original' do
      expect(fruits_ary.my_each(&:upcase)).to eql(fruits_ary)
    end

    it 'should return range equal to the original' do
      expect(raw_range.my_each { |item| item }).to eql(raw_range)
    end

    it 'should be execute the given block code' do
      cap = ''
      str_ary.my_each do |item|
        cap = item.upcase
      end
      expect(cap).to eql(str_ary.last.upcase)
    end

    it 'should work with range' do
      last = 0
      raw_range.my_each do |item|
        last = item
      end
      expect(last).to eql(raw_range.last)
    end
  end

  context '#my_each_with_index' do
    it 'should return array equal to the original' do
      expect(fruits_ary.my_each_with_index { |value| value }).to eql(fruits_ary)
    end

    it 'should return range equal to the original' do
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

  context '#my_select' do
    it 'should return filtered array based on the given block' do
      expect(fruits_ary.my_select { |value| value == 'banana' }).to eql(['banana'])
    end

    it 'should work with range' do
      expect(raw_range.my_select { |value| value if value == 1 }).to eql([1])
    end

    it 'should return Enumerable if the block is missing' do
      expect(fruits_ary.my_select.is_a?(Enumerable)).to eql(true)
    end
  end

  context '#my_all?' do
    it 'should return false based on the given block' do
      expect(fruits_ary.my_all? { |value| value == 'banana' }).to eql(false)
    end

    it 'should work with range' do
      expect(raw_range.my_all? { |val| val.is_a?(Numeric) }).to eql(true)
    end

    it 'should return true if all of the collection match the given paramenter' do
      expect([3, 3, 3, 3].my_all?(3)).to eql(true)
    end

    it 'should return true if all of the collection is a member of such class::Integer' do
      expect(number_ary.my_all? { |val| val.is_a?(Integer) }).to eql(true)
    end

    it 'should return true if all of the collection is a member of such class::Integer #in shorter form' do
      expect(number_ary.my_all?(Integer)).to eql(true)
    end

    it 'should work with a class as an paramenter; return true false all items in the array are not a member String' do
      expect(fruits_ary.my_all? { |val| val.is_a?(String) }).to eql(true)
    end

    it 'should return false if the given array has a falsy data' do
      expect([nil, true, 99].my_all?).to eql(false)
    end

    it 'should return false if the given block return false; even once' do
      expect([99, 100, 99].my_all? { |value| value == 99 }).to eql(false)
    end

    it 'should return true no falsy data is provided' do
      expect([1, true, 'hi', []].my_all?).to eql(true)
    end
  end

  context '#my_any?' do
    it 'should return true based on the given block if it returns true' do
      expect(fruits_ary.my_any? { |value| value == 'banana' }).to eql(true)
    end

    it 'should work with range' do
      expect(raw_range.my_any? { |val| val.is_a?(String) }).to eql(false)
    end

    it 'should work with regex and return false if the given paramenter not match the collection' do
      expect(fruits_ary.my_any?(/z/)).to eql(false)
    end

    it 'should work with regex and return true if the given paramenter match the collection' do
      expect(fruits_ary.my_any?(/apple/)).to eql(true)
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

  context '#my_none?' do
    it 'should return false based on the given block ' do
      expect(fruits_ary.my_none? { |value| value == 'banana' }).to eql(false)
    end

    it 'should work with range' do
      expect(raw_range.my_none? { |val| val.is_a?(String) }).to eql(true)
    end

    it 'should return true if the given array has no truthy data' do
      expect([nil, false].my_none?).to eql(true)
    end

    it 'should return true no truthy data is provided' do
      expect([].my_none?).to eql(true)
    end
  end

  context '#my_count' do
    it 'should return the length of the array if no block given' do
      expect(fruits_ary.my_count).to eql(fruits_ary.length)
    end

    it 'should work with range' do
      expect(raw_range.my_count).to eql(5)
    end

    it 'should return true if the given array has no truthy data' do
      expect(fruits_ary.my_count(100)).to eql(fruits_ary.count(100))
    end

    it 'should return true no truthy data is provided' do
      expect(fruits_ary.my_count { |item| item.eql?('banana') }).to eql(1)
    end
  end

  context '#my_map' do
    it 'should return the filtered of the array based on the given block' do
      expect(fruits_ary.my_map { |item| item.length * 100 }).to eql(fruits_ary.map { |item| item.length * 100 })
    end

    it 'should work with range' do
      expect(raw_range.my_map { |i| i * i }).to eql([1, 4, 9, 16, 25])
    end

    it 'should return Enumerable if the block is missing' do
      expect(fruits_ary.my_map.is_a?(Enumerable)).to eql(true)
    end
  end

  context '#my_inject' do
    it 'should return the accumulated value' do
      expect(number_ary.my_inject { |acc, n| acc + n }).to eql(45)
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
      expect(str_ary.inject { |memo, word| memo.length > word.length ? memo : word }).to eql('Sky-Light')
    end

    it 'should return the longest wor' do
      result = str_ary.my_inject(Hash.new(0)) do |res, vote|
        res[vote] = res[vote] + 1
        res
      end
      expect(result['Hayat']).to eql(2)
    end

    it 'should not mutate the original value' do
      number_ary.my_inject { |product, n| product * n }
      expect(number_ary).to eql([5, 6, 7, 8, 9, 10])
    end
  end

  context '#multiply_els' do
    it 'should return the accumulated value' do
      expect(multiply_els(number_ary)).to eql(151_200)
    end
  end
end
