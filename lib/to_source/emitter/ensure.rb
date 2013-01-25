module ToSource
  class Emitter
    # Emitter for ensure nodes
    class Ensure < self

      handle(Rubinius::AST::Ensure)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('begin')
        indent
        visit(node.body)
        unindent
        emit(:ensure)
        indent
        visit(node.ensure)
        unindent
        emit_end
      end

    end
  end
end
