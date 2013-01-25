module ToSource
  class Emitter
    # Emitter for conditiona attribute assignment
    class OpAssign2 < self

      handle(Rubinius::AST::OpAssign2)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
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
