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
end