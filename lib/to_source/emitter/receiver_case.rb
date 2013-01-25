module ToSource
  class Emitter
    # Emitter for case statment nodes
    class ReceiverCase < self

      handle(Rubinius::AST::ReceiverCase)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('case ')
        visit(node.receiver)
        emit_whens
        emit_else
        emit_end
      end

      # Emit else
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_else
        body = node.else
        return if body.kind_of?(Rubinius::AST::NilLiteral)
        emit('else')
        indented do
          visit(body)
        end
      end

      # Emit whens
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_whens
        first = true
        node.whens.each do |member|
          new_line if first
          first = false
          visit(member)
        end
      end

    end
  end
end
