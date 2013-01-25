module ToSource
  class Emitter
    # Emitter for unless
    class Unless < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('unless ')
        visit(condition)
        indented do
          visit(else_body)
        end
        emit_end
      end

      # Emit condition
      #
      # @return [undefined]
      #
      # @api private
      #
      def condition
        node.condition
      end

      # Emit else
      #
      # @return [undefined]
      #
      # @api private
      #
      def else_body
        node.else
      end

    end
  end
end
