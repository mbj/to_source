module ToSource
  class Emitter
    # Emitter for nth global variable reference
    class NthRef < self

      handle(Rubinius::AST::NthRef)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit("$#{node.which}")
      end

    end
  end
end
