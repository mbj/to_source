module ToSource
  class Emitter
    class Unless < self

    private
      
      def dispatch
        emit('unless ')
        visit(condition)
        indent
        visit(else_body)
        unindent
        emit_end
      end

      def condition
        node.condition
      end

      def else_body
        node.else
      end

    end
  end
end
