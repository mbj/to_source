module ToSource
  class Emitter
    # Emitter for begin constructs
    class Begin < self

      handle(Rubinius::AST::Begin)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('begin')
        emit_body
        emit_end
      end

      # Emit body
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_body
        indent
        body = node.rescue
        case body
        when Rubinius::AST::Rescue
          emit_rescue(body)
        when Rubinius::AST::Ensure
          emit_ensure(body)
        else
          visit(body)
          unindent
        end
      end

      # Emit ensure
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_ensure(node)
        visit(node.body)
        unindent
        emit(:ensure)
        indented do
          visit(node.ensure)
        end
      end

      # Emit rescue
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_rescue(node)
        visit(node.body)
        unindent
        visit(node.rescue)
      end

    end
  end
end
