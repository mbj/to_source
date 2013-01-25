module ToSource
  class Emitter
    # Emitter for block argument
    class BlockArgument < self

      handle(Rubinius::AST::BlockArgument)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('&')
        emit(node.name)
      end

    end
  end
end
