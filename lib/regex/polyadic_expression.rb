# File: polyadic_expression.rb

require_relative 'compound_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. An element that is part of a regular expression &
  # that has its own child sub-expressions.
  class PolyadicExpression < CompoundExpression
    # The aggregation of child elements
    attr_reader(:children)

    # Constructor.
    def initialize(theChildren)
      super()
      @children = theChildren
    end

    # Append the given child to the list of children.
    # TODO: assess whether to defer to a subclass NAryExpression
    def <<(aChild)
      @children << aChild

      return self
    end
    
    def done!()
      children.each(&:done!)
      children.each_with_index do |child, index|
        break if index == children.size - 1
        next_child = children[index+1]
        if next_child.kind_of?(Lookaround) && next_child.dir == :behind
          # Swap children: lookbehind regex must precede pattern
          @children[index+1] = child
          @children[index] = next_child
        end
      end
    end

    # Build a depth-first in-order children visitor.
    # The visitor is implemented as an Enumerator.
    def df_visitor()
      root = children # The visit will start from the children of this object

      visitor = Enumerator.new do |result| # result is a Yielder
        # Initialization part: will run once
        visit_stack = [root] # The LIFO queue of nodes to visit

        begin # Traversal part (as a loop)
          top = visit_stack.pop
          if top.kind_of?(Array)
            next if top.empty?
            currChild = top.pop
            visit_stack.push top
          else
            currChild = top
          end

          result << currChild # Return the visited child

          unless currChild.atomic?
            # in-order traversal implies LIFO queue
            children_to_enqueue = currChild.children.reverse
            visit_stack.push(children_to_enqueue)
          end
        end until visit_stack.empty?
      end
      
      return visitor
    end
  end # class
end # module

# End of file
