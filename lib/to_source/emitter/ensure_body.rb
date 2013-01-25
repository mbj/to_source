module ToSource
  class Emitter
    # Emitter for ensure body
    class EnsureBody < self

    private

      delegate(:body)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(body)
        unindent
        emit(:ensure)
        indented do
          visit(node.ensure)
        end
      end

    end
  end
end
