module ToSource
  class Emitter
    # Emitter for element assignment nodes
    class ElementAssignment < self

      handle(Rubinius::AST::ElementAssignment)

    private

      delegate(:receiver)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        index, value = node.arguments.array
        visit(receiver)
        emit('[')
        visit(index)
        emit('] = ')
        visit(value)
      end

    end
  end
end
