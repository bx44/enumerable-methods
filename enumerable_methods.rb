#!/usr/bin/ruby

module Enumerable # rubocop:disable Metrics/ModuleLength
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

  def my_all?(pat = nil)
    if block_given?
      my_each do |x|
        return false unless yield(x)
      end
    else
      condition = condition_picker(pat)
      my_each do |x|
        return false unless condition.call(x)
      end
    end
    true
  end

  def my_any?(pat = nil)
    if block_given?
      my_each do |x|
        return true if yield(x)
      end
    else
      condition = condition_picker(pat)
      my_each do |x|
        return true if condition.call(x)
      end
    end
    false
  end

  def my_none?(pat = nil)
    if block_given?
      my_each do |x|
        return false if yield(x)
      end
    else
      condition = condition_picker(pat)
      my_each do |x|
        return false if condition.call(x)
      end
    end
    true
  end

  def condition_picker(pat)
    if pat.is_a?(Class)
      condition = proc { |x| x.is_a?(pat) }
    elsif pat.class == Regexp
      condition = proc { |x| pat === x } # rubocop:disable Style/CaseEquality
    elsif !pat.nil?
      condition = proc { |x| x == pat }
    elsif pat.nil?
      condition = proc { |x| x }
    end
    condition
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

  def my_inject(*args)
    sym, initial = nil
    args.each do |x|
      if x.is_a?(Symbol)
        sym = x
      else
        initial = x
      end
    end
    if initial.nil?
      default_intial = true
      initial ||= self[0]
    end
    if !block_given? && !sym.nil?
      my_each_with_index do |x, id|
        next if id == 0 && default_intial
        initial = x.send(sym, initial)
      end
      return initial
    end
    my_each_with_index do |x, id|
      next if id == 0 && default_intial
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
