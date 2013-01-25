module ToSource
  class Emitter
    # Base class for emitters with static content
    class Static < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(self.class::SYMBOL)
      end

      # Emitter for next nodes
      class Next < self

        handle(Rubinius::AST::Next)
        SYMBOL = :next

      end

      # Emitter for current exception node
      class CurrentException < self

        handle(Rubinius::AST::CurrentException)
        SYMBOL = :'$!'

      end

      # Emitter for self node
      class Self < self

        handle(Rubinius::AST::Self)
        SYMBOL = :self

      end

      # Emitter for file node
      class File < self

        handle(Rubinius::AST::File)
        SYMBOL = :__FILE__

      end

      # Emitter for redo node
      class Redo < self

        handle(Rubinius::AST::Redo)
        SYMBOL = :redo

      end

      # Emitter for retry node
      class Retry < self

        handle(Rubinius::AST::Retry)
        SYMBOL = :retry

      end

      # Emitter for rubinius specific type constant
      class TypeConstant < self

        handle(Rubinius::AST::TypeConstant)
        SYMBOL = 'Rubinius::Type'

      end

    end
  end
end
