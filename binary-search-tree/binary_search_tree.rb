class Bst
  attr_reader :node

  class Node
    attr_reader :data
    attr_accessor :left, :right

    # Each node has   data, a left node and a right node
    def initialize(data)
      @data = data
      @left = nil
      @right = nil
    end

    # Insertion requires walking down the tree until an insertion point is found
    def insert(data_value)
      current_node = self
      while true
        if data_value <= current_node.data
          if current_node.left.nil?
            current_node.left = Node.new(data_value)
            return
          else
            current_node = current_node.left
          end
        else
          if current_node.right.nil?
            current_node.right = Node.new(data_value)
            return
          else
            current_node = current_node.right
          end
        end
      end
    end

    # Enumeration requires a deferred enumerator or actual enumeration
    def each(&block)
      return to_enum(:each) unless block_given?

      walk_tree(self, &block)
    end

    # For each node we visit the left node, current data, right node,
    # essentially walking through the tree and emitting the lowest parts first via recursion
    def walk_tree(node, &block)
      walk_tree(node.left, &block) if node.left
      yield node.data
      walk_tree(node.right, &block) if node.right
    end

  end

  # create the top most node
  def initialize(data)
    @node = Node.new(data)
  end

  private

  # delegate every call to the top level node
  def method_missing(name, *args, **kwargs, &block)
    @node.send(name, *args, **kwargs, &block)
  end

  def respond_to_missing?(name, include_private = false)
    @node.respond_to?(name, include_private)
  end

end
