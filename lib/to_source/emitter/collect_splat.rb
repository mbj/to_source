module ToSource
  class Emitter

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
        splat = node.instance_variable_get(:@splat)
        if splat.kind_of?(Rubinius::AST::PushArgs)
          run(PushArgs, splat)
        else
          visit(splat)
        end
      end
    end
  end
end
