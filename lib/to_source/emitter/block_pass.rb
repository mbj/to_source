module ToSource
  class Emitter
    # Emitter for block pass
    class BlockPass < self

      handle(Rubinius::AST::BlockPass19)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('&')
        visit(node.body)
      end

    end
  end
end
