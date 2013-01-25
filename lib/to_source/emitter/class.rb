module ToSource
  class Emitter
    # Emitter for class nodes
    class Class < self

      handle(Rubinius::AST::Class)

    private

      delegate(:name, :body)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(:class)
        space
        visit(name)
        emit_superclass
        indented do
          visit(body)
        end
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
