module ToSource
  class Emitter
    # Emitter for match operator
    class Match3 < self

      handle(Rubinius::AST::Match3)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        util = node
        visit(util.value)
        emit(' =~ ')
        visit(util.pattern)
      end

    end
  end
end
