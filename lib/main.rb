module Enumerable
  def my_each
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    for item in array
      yield(item)
    end
    array
  end
end