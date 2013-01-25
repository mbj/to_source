module ToSource
  class Emitter
    # Emitter for match operator
    class Match2 < self

      handle(Rubinius::AST::Match2)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        util = node
        visit(util.pattern)
        emit(' =~ ')
        visit(util.value)
      end

    end
  end
end
