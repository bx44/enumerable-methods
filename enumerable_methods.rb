#!/usr/bin/ruby
# rubocop:disable Style/CaseEquality

module Enumerable
   def my_each
    return self.to_enum unless block_given?
    for x in self
        yield(x)
    end
    return self
   end
   def my_each_with_index
    return self.to_enum unless block_given?
    i = 0
    for x in self
        yield(x, i)
        i += 1
    end
    return self
   end
   def my_select
    return self.to_enum unless block_given?
    new_array = []
    self.my_each do |x|
        new_array.push(x) if yield(x)
    end
    return new_array
   end
end