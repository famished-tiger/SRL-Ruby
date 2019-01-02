# File: polyadic_expression.rb

require_relative 'compound_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. An element that is part of a regular expression &
  # that has its own child sub-expressions.
  class PolyadicExpression < CompoundExpression
    # @return [Array<Regex::Expression>] The aggregation of child elements
    attr_reader(:children)

    # Constructor.
    # @param theChildren [Array<Regex::Expression>]
    def initialize(theChildren)
      super()
      @children = theChildren
    end

    # Append the given child to the list of children.
    # TODO: assess whether to defer to a subclass NAryExpression
    # param aChild [Regex::Expression]
    def <<(aChild)
      @children << aChild

      return self
    end

    # Notification that the parse tree construction is complete.
    def done!
      children.each(&:done!)
      children.each_with_index do |child, index|
        break if index == children.size - 1

        next_child = children[index + 1]
        if next_child.kind_of?(Lookaround) && next_child.dir == :behind
          # Swap children: lookbehind regex must precede pattern
          @children[index + 1] = child
          @children[index] = next_child
        end
      end
    end

    # Apply the 'lazy' option to the child elements
    def lazy!
      children.each(&:lazy!)
    end

    # Build a depth-first in-order children visitor.
    # The visitor is implemented as an Enumerator.
    def df_visitor
      root = children # The visit will start from the children of this object

      visitor = Enumerator.new do |result| # result is a Yielder
        # Initialization part: will run once
        visit_stack = [root] # The LIFO queue of nodes to visit

        loop do # Traversal part (as a loop)
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

          break if visit_stack.empty?
        end
      end

      return visitor
    end
  end # class
end # module

# End of file
