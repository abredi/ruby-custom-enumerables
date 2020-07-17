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

  def my_all?
    flag = true
    array.my_each do |item|
      flag = yield(item)
      break unless flag
    end
    flag
  end

  def my_any?
    flag = array.empty?
    array.my_each do
      break if yield(item)
    end
    flag
  end

  def my_none?
    flag = true
    array.my_each do
      flag = yield(item)
      break if flag
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
    array = is_a?(Range) ? to_a : self

    filtered = []
    if prok
      array.my_each { |item| filtered.push(prok.call(item)) }
    else
      array.my_each { |item| filtered.push(yield(item)) }
    end
    filtered
  end

  def my_inject(init = nil)
    array = is_a?(Range) ? to_a : self

    acc = init
    unless init.is_a?(Integer)
      acc = array[0]
      array.shift
    end

    if init.is_a?(Symbol)
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

  def multiply_els
    my_inject { |mul, n| mul * n }
  end
end
