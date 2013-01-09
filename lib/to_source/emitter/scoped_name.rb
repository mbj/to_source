module ToSource
  class Emitter
    class ScopedName < self

      handle(Rubinius::AST::ScopedClassName)
      handle(Rubinius::AST::ScopedModuleName)
      handle(Rubinius::AST::ScopedConstant)

    private

      delegate(:parent, :name)

      def dispatch
        visit(parent)
        emit('::')
        emit(name)
      end

    end
  end
end
