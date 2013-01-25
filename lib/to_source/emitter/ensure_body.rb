module ToSource
  class Emitter
    # Emitter for ensure body
    class EnsureBody < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.body)
        unindent
        emit('ensure')
        indent
        visit(node.ensure)
        unindent
      end

    end
  end
end
