module ToSource
  class Emitter
    class Match3 < self

      handle(Rubinius::AST::Match3)

    private

      def dispatch
        util = node
        visit(util.value)
        emit(' =~ ')
        visit(util.pattern)
      end

    end
  end
end
