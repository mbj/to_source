module ToSource
  class Emitter
    # Emitter for spat when nodes
    class SplatWhen < self

      handle(Rubinius::AST::SplatWhen)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('*')
        visit(node.condition)
      end

    end
  end
end
