#!/usr/bin/ruby
# rubocop:disable Style/CaseEquality

module Enumerable
   def my_each
    return self.to_enum unless block_given?
    for x in self
        yield(x)
    end
    self
   end
   def my_each_with_index
    return self.to_enum unless block_given?
    i = 0
    for x in self
        yield(x, i)
        i += 1
    end
    self
   end
   def my_select
    return self.to_enum unless block_given?
    new_array = []
    self.my_each do |x|
        new_array.push(x) if yield(x)
    end
    new_array
   end
   def my_all?
    unless block_given?
        self.my_each do |x|
            return false unless x
        end
        return true
    end
    self.my_each do |x|
        return false unless yield(x)
    end
    true
   end
   def my_any?
    unless block_given?
        self.my_each do |x|
            return true if x
        end
        return false
    end
    self.my_each do |x|
        return true if yield(x)
    end
    false
   end
   def my_none?
    unless block_given?
        self.my_each do |x|
            return false if x
        end
        return true
    end
    self.my_each do |x|
        return false if yield(x)
    end
    true
   end
   def my_count(item=nil)
    count = 0
    if !block_given? || item != nil
        return self.length unless item
        self.my_each do |x|
            count += 1 if x == item
        end
        return count
    end
    self.my_each do |x|
        count += 1 if yield(x)
    end
    count
   end
   def my_map(proc)
    # return self.to_enum unless block_given?
    new_array = []
    self.my_each do |x|
        new_array.push proc.call(x)
        # new_array.push yield(x)
    end
    new_array
   end
   def my_inject(initial=nil)
    initial ||= self[0]
    self.my_each do |x|
        initial = yield(initial, x)
    end
    initial
   end
end

def multiply_els(arr)
    arr.my_inject do |memo, x|
        memo *= x
    end
end