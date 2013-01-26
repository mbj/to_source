module ToSource
  class Emitter

    class PushArgs < self

      handle(Rubinius::AST::PushArgs)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.arguments)
        emit(', ')
        visit(node.value)
      end
    end

    # Emitter for collect splat nodes
    class CollectSplat < self

      handle(Rubinius::AST::CollectSplat)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_splat
        emit(', ')
        emit_last
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_last
        # FIXME: Add attr reader
        visit(node.instance_variable_get(:@last))
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        # FIXME: Add attr reader
        visit(node.instance_variable_get(:@splat))
      end
    end
  end
end
