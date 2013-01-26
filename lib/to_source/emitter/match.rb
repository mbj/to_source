module ToSource
  class Emitter
    class Match < self

      handle(Rubinius::AST::Match)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.pattern)
      end

    end
  end
end
