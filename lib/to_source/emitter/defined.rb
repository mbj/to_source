module ToSource
  class Emitter
    # Emitter for defined? node
    class Defined < self

      handle(Rubinius::AST::Defined)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('defined?(')
        visit(node.expression)
        emit(')')
      end

    end
  end
end
