module ToSource
  class Emitter
    # Emitter for splat nodes
    class Splat < self

      handle(Rubinius::AST::SplatValue)
      handle(Rubinius::AST::RescueSplat)

    private

      delegate(:value)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('*')
        emit_value
      end

      # Emit value
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_value
        visit(value)
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

        # Return value
        #
        # @return [nil]
        #
        # @api private
        #
        def value
        end

      end
    end
  end
end
