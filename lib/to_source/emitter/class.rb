module ToSource
  class Emitter
    # Emitter for class nodes
    class Class < self

      handle(Rubinius::AST::Class)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(:class)
        space
        visit(node.name)
        emit_superclass
        indent
        visit(node.body)
        unindent
        emit_end
      end

      # Emit superclass
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_superclass
        superclass = node.superclass
        return if superclass.kind_of?(Rubinius::AST::NilLiteral)
        emit(' < ')
        visit(superclass)
      end

    end
  end
end
