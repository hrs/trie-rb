class Trie
  include Enumerable

  class Node
    attr_accessor :next

    def initialize
      @next = Hash.new
    end
  end

  def initialize(*strs)
    @root = Node.new
    strs.each do |s|
      add(s)
    end
  end

  def add(str)
    curr = @root
    
    str.each_char do |c|
      curr.next[c] = Node.new unless curr.next[c]
      curr = curr.next[c]
    end
    
    curr.next[:end] = true
  end
  
  def remove(str)
    return true unless include?(str)
    
    curr = @root
    rem_node = @root
    rem_key = str[0]
    
    str.each_char do |c|
      if curr.next[:end]
        rem_node = curr
        rem_key = c
      end
      curr = curr.next[c]
    end
    
    curr.next.delete(:end)
    if curr.next.empty?
      rem_node.next.delete(rem_key)
    end
  end

  def each(acc = '', curr = @root, &blk)
    yield acc if curr.next[:end]
    
    curr.next.keys.select { |k| k != :end }.sort.each do |c|
      each(acc + c, curr.next[c], &blk)
    end
  end

  def empty?
    @root.next.empty?
  end

  def include?(str)
    curr = @root
    
    str.each_char do |c|
      return false unless curr.next[c]
      curr = curr.next[c]
    end
    
    curr.next[:end]
  end
end
