module ToSource
  class Emitter
    class OpAssign1 < self

      handle(Rubinius::AST::OpAssign1)

    private

      def dispatch
        util = node
        visit(util.receiver)
        emit('[')
        visit(util.arguments.array.first)
        emit('] ||= ')
        visit(util.value)
      end

    end
  end
end
