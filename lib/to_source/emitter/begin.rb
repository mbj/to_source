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

        if body.kind_of?(Rubinius::AST::Rescue)
          emit_rescue(body)
          return
        end

        if body.kind_of?(Rubinius::AST::Ensure)
          emit_ensure(body)
          return
        end

        visit(body)
        unindent
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
        indent
        visit(node.ensure)
        unindent
      end

      # Emit rescue
      #
      # @return [undefined]
      #
      # @pai private
      #
      def emit_rescue(node)
        visit(node.body)
        unindent
        visit(node.rescue)
      end

    end
  end
end
