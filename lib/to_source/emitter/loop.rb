module ToSource
  class Emitter
    # Base class for loop node emittrs
    class Loop < self

    private
      
      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(self.class::KEYWORD)
        space
        visit(condition)
        indented do
          visit(body)
        end
        emit_end
      end

      delegate :condition, :body

      # Emitter for while nodes
      class While < self
        handle(Rubinius::AST::While)
        KEYWORD = :while
      end

      # Emitter for until nodes
      class Until < self
        handle(Rubinius::AST::Until)
        KEYWORD = :until
      end

    end
  end
end
