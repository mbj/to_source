module ToSource
  class Emitter
    # Emitter for attribute assignments
    class AttributeAssignment < self

      handle(Rubinius::AST::AttributeAssignment)

    private

      delegate(:receiver, :name)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(receiver)
        emit('.')
        emit(name)
        space
        visit(node.arguments.array.first)
      end

    end
  end
end
