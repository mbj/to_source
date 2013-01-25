module ToSource
  class Emitter
    # Emitter for attribute assignments
    class AttributeAssignment < self

      handle(Rubinius::AST::AttributeAssignment)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.receiver)
        emit('.')
        emit(node.name)
        space
        visit(node.arguments.array.first)
      end

    end
  end
end
