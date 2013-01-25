module ToSource
  class Emitter
    # Emitter for element assignment nodes
    class ElementAssignment < self

      handle(Rubinius::AST::ElementAssignment)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        index, value = node.arguments.array
        visit(node.receiver)
        emit('[')
        visit(index)
        emit('] = ')
        visit(value)
      end

    end
  end
end
