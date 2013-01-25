module ToSource
  class Emitter
    # Emitter for element reference nodes
    class ElementReference < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.receiver)
        emit('[')
        visit(node.arguments.array.first)
        emit(']')
      end

    end
  end
end
