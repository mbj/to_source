module ToSource
  class Emitter
    # Emit to array node
    class ToArray < self

      handle(Rubinius::AST::ToArray)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.value)
      end

    end
  end
end
