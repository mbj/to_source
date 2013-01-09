module ToSource
  class Emitter
    class OpAssign2 < self

      handle(Rubinius::AST::OpAssign2)

    private

      def dispatch
        util = node
        visit(util.receiver)
        emit('.')
        emit(util.name)
        emit(' |= ')
        visit(util.value)
      end

    end
  end
end
