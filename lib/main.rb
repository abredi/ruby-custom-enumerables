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

end