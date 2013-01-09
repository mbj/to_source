module ToSource
  class Emitter
    class Loop < self

    private

      def dispatch
        emit(self.class::KEYWORD)
        space
        visit(condition)
        indent
        visit(body)
        unindent
        emit_end
      end

      def condition
        node.condition
      end

      def body
        node.body
      end

      class While < self
        handle(Rubinius::AST::While)
        KEYWORD = :while
      end

      class Until < self
        handle(Rubinius::AST::Until)
        KEYWORD = :until
      end

    end
  end
end
