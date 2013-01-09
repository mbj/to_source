module ToSource
  class Emitter
    class Module < self

      handle(Rubinius::AST::Module)

    private

      def dispatch
        util = node
        emit('module ')
        visit(util.name)
        indent
        visit(util.body)
        unindent
        emit_end
      end

    end
  end
end
