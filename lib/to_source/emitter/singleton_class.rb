module ToSource
  class Emitter

    class SingletonClass < self

      handle(Rubinius::AST::SClass)

    private

      def dispatch
        emit('class << ')
        visit(node.receiver)
        emit_body
        emit_end
      end

      def emit_body
        indent
        # FIXME: attr_reader missing on Rubinius::AST::SClass
        visit(node.instance_variable_get(:@body))
        unindent
      end

    end
  end
end
