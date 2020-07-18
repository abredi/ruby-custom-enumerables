def check_condition(flag, array, cond)
  if cond.is_a?(Class)
    array.my_each do |item|
      return !flag if item.is_a?(cond)
    end
  else
    array.my_each do |item|
      return !flag if item == cond
    end
  end
  flag
end

def check_block(flag, array)
  array.my_each do |item|
    return !flag if item
  end
  flag
end
module Enumerable
  def my_each
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self

    array.map { |item| yield(item) }
    array
  end

  def my_each_with_index
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    index = -1
    array.my_each { |item| yield(item, index += 1) }
    self
  end

  def my_select
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    filtered = []
    array.my_each { |item| filtered.push(item) if yield(item) }
    filtered
  end

  def my_all?(cond = nil)
    array = is_a?(Range) ? to_a : self
    flag = true
    return check_condition(flag, array, cond) if cond

    return check_block(flag, array) unless block_given?

    array.my_each do |item|
      return false unless yield(item)
    end
    flag
  end

  def my_any?(cond = nil)
    array = is_a?(Range) ? to_a : self
    flag = false

    return check_condition(flag, array, cond) if cond

    return check_block(flag, array) unless block_given?

    array.my_each do |item|
      return true if yield(item)
    end
    flag
  end

  def my_none?(cond = nil)
    array = is_a?(Range) ? to_a : self
    flag = true

    return check_condition(flag, array, cond) if cond

    return check_block(flag, array) unless block_given?

    array.my_each do |item|
      return false if yield(item)
    end
    flag
  end

  def my_count(arg = nil)
    array = is_a?(Range) ? to_a : self

    if arg
      return array.my_select { |val| val if val == arg }.length
    end

    count = array.length

    return count unless block_given?

    array.my_each do |item|
      count -= 1 unless yield(item)
    end
    count
  end

  def my_map(prok = nil)
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self

    filtered = []
    if prok
      array.my_each { |item| filtered.push(prok.call(item)) }
    else
      array.my_each { |item| filtered.push(yield(item)) }
    end
    filtered
  end

  def my_inject(init = nil, symbol = nil)
    array = is_a?(Range) ? to_a : self

    acc = init

    if !init || init.is_a?(Symbol)
      acc = array[0]
      array.shift
    end

    if init.is_a?(Symbol) || symbol.is_a?(Symbol)
      init = symbol || init
      array.my_each do |item|
        acc = acc.send(init, item)
      end
      return acc
    end

    array.my_each do |item|
      acc = yield(acc, item)
    end
    acc
  end

  def multiply_els(ary)
    ary.my_inject do |acc, n|
      acc * n
    end
  end
end
