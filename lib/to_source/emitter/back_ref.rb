module ToSource
  class Emitter

    # Emitter for various access nodes
    class BackRef < self

      handle(Rubinius::AST::BackRef)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      # 
      def dispatch
        emit("$#{node.kind}")
      end

    end
  end
end
