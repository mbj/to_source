module ToSource
  class Emitter
    # Emitter for conditiona element assignment
    class OpAssign1 < self

      handle(Rubinius::AST::OpAssign1)

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
        emit('[')
        visit(util.arguments.array.first)
        emit('] ||= ')
        visit(util.value)
      end

    end
  end
end
