module ToSource
  class Emitter
    # Emitter for element reference nodes
    class ElementReference < self

    private

      delegate(:receiver)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(receiver)
        emit('[')
        visit(node.arguments.array.first)
        emit(']')
      end

    end
  end
end
