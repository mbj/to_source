module ToSource
  class Emitter

    # Emitter for undef nodes
    class Undef < self

      handle(Rubinius::AST::Undef)
      SYMBOL = :undef

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(:undef)
        space
        visit(node.name)
      end

    end
  end
end
