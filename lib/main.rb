module Enumerable
  def my_each
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    for item in array
      yield(item)
    end
    array
  end

  def my_each_with_index
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    index = -1
    for item in array
      yield(item, index+=1)
    end
    array
  end
  
  def my_select
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    filtered = []
    for item in array
      filtered.push(item) if yield(item)
    end
    filtered
  end
   
  def my_all?
    flag = true
    for item in array
      flag = yield(item)
      break unless flag
    end
    flag
  end

  def my_none?
    flag = true
    for item in array
      flag = yield(item)
      break if flag
    end
    flag
  end
  
  def my_count(arg = nil)
    array = is_a?(Range) ? to_a : self
    if arg
      return array.select{|val| val if val == arg}.length   
    end
    return array.length unless block_given?
    count = array.length
    for item in array
      count-=1 unless yield(item)
    end
    count
  end

  def my_map(prok = nil)
    array = is_a?(Range) ? to_a : self

    filtered = []
    if prok
      for item in array
        filtered.push(prok.call(item)) 
      end
    else
      for item in array
        filtered.push(yield(item))
      end
    end
    
    filtered
  end

  def my_each_with_index
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    index = -1
    for item in array
      yield(item, index+=1)
    end
    array
  end
  
  def my_inject(init = nil)
    array = is_a?(Range) ? to_a : self

    acc =  init

    unless init.is_a?(Integer)
      acc = array[0]
      array.shift
    end

    if init.is_a?(Symbol)
      for item in array do
        acc = acc.send(init, item)
      end
      return acc
    end

    for item in array do
      acc = yield(acc, item)
    end
    acc
  end

  def multiply_els
    self.my_inject { |mul, n| mul * n }
  end

end

print [2,4,5].multiply_els