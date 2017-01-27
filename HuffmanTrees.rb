#Andrew Fuller
#Huffman Coding Tree
#JMU Spring '16


class Huffman
    
	#creates internal Huffman tree for given text and then an encoding table
	def initialize(text)
		@text = text
		@tree = huffTree(text)
		@table = Hash.new("")
		table()
	end
	
	#returns given text
	def text
		return @text
	end

	#returns Huffman coding table
	#returns empty hash if text char count is less than 2
	def table
		empty = Hash.new
		if @text.length < 2
			return empty
		end
		tableHelper(@tree, "")
		return @table
	end

	#called by table to recursively set chars to new bit counts 
	def tableHelper(node, text)
		if(node.char == nil)
			tableHelper(node.left, text+"0")
			tableHelper(node.right, text+"1")
		else
			@table[node.char] = text
		end
		return text
	end

	#encodes given text based on previously created Huffman table
	def encode(text = nil)
		text = @text  if text == nil
		result = ""
		text.each_char {|ch| result += @table[ch]}
		return result
	end

	#decodes given bit string based on previously created Huffman table
	def decode(bit_string)
		str = ""
		result = ""
		node = @tree

		bit_string.each_char do |ch|
			str += ch
			if(ch.to_i == 0 and node.left != nil)
				node = node.left
				if(node.left == nil and node.right == nil)
					result += @table.key(str)
					str = ""
					node = @tree
				end
			elsif(ch.to_i == 1 and node.right != nil)
				node = node.right
				if(node.left == nil and node.right == nil)
					result += @table.key(str)
					str = ""
					node = @tree
				end
			else
				result += @table.key(str)
				str = ""
				node = @tree
			end
		end
		result
	end

	#creates the Huffman tree called in the initializer method
	def huffTree(text)
		queue = Array.new
		count = countChars(text)

		count.each do |char, freq|
			node = Node.new(char, freq)
			queue.push(node)
		end
		queue.sort_by!{|ch| ch.freq}

		while queue.size != 1
			node = Node.new
			node.left = queue.shift
			node.right = queue.shift
			node.freq = node.left.freq + node.right.freq
			queue.push(node)
			queue.sort_by!{|ch| ch.freq}
		end
    return queue[0]
	end

	#counts occurances of each char in a given string
	def countChars(str)
		c = Hash.new 0
		str.each_char do |ch|
			c[ch] += 1
		end
		return c
	end

	attr_accessor :text
    
end



#class to create new nodes
class Node

  def initialize(char = nil, freq = 0)
      @char = char
      @freq = freq
      @left = nil
      @right = nil
  end

  def to_s
    to_string(0, self)
  end

  #helper method used for visually debugging
  def to_string(indent, node)
    if node == nil
       print " "*indent + "nil"
       return
    end
    print " "*indent + "ch: #{node.char}\n"
    print " "*indent + "freq: #{node.freq}\n"
    print " "*indent + "left: \n"
    to_string(indent+3, node.left)
    print "\n"
    print " "*indent + "right: \n"
    to_string(indent+3, node.right)
    print "\n"
  end
	attr_accessor :char, :freq, :left, :right
end


puts ""
h = Huffman.new("First learn computer science and all the theory. Next develop a programming style. Then forget all that and just hack. - George Carrette")

puts ""
puts "This is what your entered text looks like:"
puts h.text

puts ""
puts "This is the corresponding hash table formed from the characters entered:"
puts h.table

puts ""
puts "This is what the text entered looks like encoded by the table above:"
puts h.encode

puts ""
puts "Using the hash table above, you can encode a new message, such as: 111110010101001011001110101111101101011111110100101010011011111001000000101001111100"

puts ""
puts "Which decodes to:"
puts h.decode("111110010101001011001110101111101101011111110100101010011011111001000000101001111100")
