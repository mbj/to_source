module ToSource
  class Emitter
    # Emitter for zsuper nodes
    class ZSuper < self

      handle(Rubinius::AST::ZSuper)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('super')
        block = node.block
        visit(block) if block
      end

    end
  end
end
