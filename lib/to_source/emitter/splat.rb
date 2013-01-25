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

    end
  end
end
