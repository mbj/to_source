module ToSource
  class Emitter
    # Emitter for splat nodes
    class Splat < self

      handle(Rubinius::AST::SplatValue)
      handle(Rubinius::AST::RescueSplat)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('*')
        visit(node.value)
      end

      # Emitter for empty splat
      class Empty < self

        handle(Rubinius::AST::EmptySplat)

      private

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit('*')
        end

      end
    end
  end
end
