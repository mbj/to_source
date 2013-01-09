module ToSource
  class Emitter

    class Rescue < self

      handle(Rubinius::AST::Rescue)

    private

      def dispatch
        util = node
        emit('begin')
        indent
        visit(util.body)
        unindent
        visit(util.rescue)
        emit_end
      end

    end
  end
end
