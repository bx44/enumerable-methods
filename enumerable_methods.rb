#!/usr/bin/ruby

module Enumerable
  def my_each
    return to_enum unless block_given?

    for x in self # rubocop:disable Style/For
      yield(x)
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    for x in self # rubocop:disable Style/For
      yield(x, i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    new_array = []
    my_each do |x|
      new_array.push(x) if yield(x)
    end
    new_array
  end

  def my_all?
    unless block_given?
      my_each do |x|
        return false unless x
      end
      return true
    end
    my_each do |x|
      return false unless yield(x)
    end
    true
  end

  def my_any?
    unless block_given?
      my_each do |x|
        return true if x
      end
      return false
    end
    my_each do |x|
      return true if yield(x)
    end
    false
  end

  def my_none?
    unless block_given?
      my_each do |x|
        return false if x
      end
      return true
    end
    my_each do |x|
      return false if yield(x)
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if !block_given? || !item.nil?
      return length unless item

      my_each do |x|
        count += 1 if x == item
      end
      return count
    end
    my_each do |x|
      count += 1 if yield(x)
    end
    count
  end

  def my_map(proc = nil)
    return to_enum if !block_given? && !proc

    new_array = []
    my_each do |x|
      if proc
        new_array.push proc.call(x)
      else
        new_array.push yield(x)
      end
    end
    new_array
  end

  def my_inject(initial = nil)
    initial ||= self[0]
    my_each do |x|
      initial = yield(initial, x)
    end
    initial
  end
end

def multiply_els(arr)
  arr.my_inject do |memo, x|
    memo * x
  end
end
