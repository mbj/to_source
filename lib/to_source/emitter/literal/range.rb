module ToSource
  class Emitter
    class Literal
      # Base class for range emitters
      class Range < self

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          util = node
          parantheses do
            visit(util.start)
            emit(self.class::TOKEN)
            visit(util.finish)
          end
        end

        # Emitter for incluive range nodes
        class Inclusive < self

          handle(Rubinius::AST::Range)
          TOKEN = '..'.freeze

        end

        # Emitter for exclusive range nodes
        class Exclude < self

          handle(Rubinius::AST::RangeExclude)
          TOKEN = '...'.freeze

        end

      end
    end
  end
end
