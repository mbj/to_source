module ToSource
  class Emitter
    # Base class for literal emitters
    class Literal < self

      # Emitter for empty array nodes
      class EmptyArray < self

        handle(Rubinius::AST::EmptyArray)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit('[]')
        end
      end

      # Emitter for array nodes
      class Array < self

        handle(Rubinius::AST::ArrayLiteral)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit('[')
          run(Util::DelimitedBody, node.body)
          emit(']')
        end
      end

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
          visit(util.start)
          emit(self.class::TOKEN)
          visit(util.finish)
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

      # Emitter for hash nodes
      class Hash < self

        handle(Rubinius::AST::HashLiteral)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit '{'
          emit_body
          emit '}'
        end

        # Emit body
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_body
          body = node.array.each_slice(2).to_a
          max  = body.length - 1
          body.each_with_index do |(key, value), index|
            visit(key)
            emit(' => ')
            visit(value)

            if index < max 
              emit(', ')
            end
          end
        end

      end

      # Base class for emiiters that emit via #inspect
      class Inspect < self

        handle(Rubinius::AST::SymbolLiteral)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit(value.inspect)
        end

        delegate :value

        # Base class for emitters with static value
        class Static < self

        private

          # Return value
          #
          # @return [Object]
          #
          # @api private
          #
          def value
            self.class::VALUE
          end

          # Emitter for true literal nodes
          class True < self
            handle(Rubinius::AST::TrueLiteral)
            VALUE = true
          end

          # Emitter for false literal nodes
          class False < self
            handle(Rubinius::AST::FalseLiteral)
            VALUE = false
          end

          # Emitter for nil literal nodes
          class Nil < self
            handle(Rubinius::AST::NilLiteral)
            VALUE = nil
          end
        end

        # Emitter for regexp literal nodes
        class Regexp < self

          handle(Rubinius::AST::RegexLiteral)

        private

          # Return value to inspect
          #
          # @return [Regexp]
          #
          # @api private
          #
          def value
            ::Regexp.new(node.source)
          end
        end

        # Emitter for string litera nodes
        class String < self

          handle(Rubinius::AST::StringLiteral)

        private

          # Return value to inspect
          #
          # @return [String]
          #
          # @api private
          #
          def value
            node.string
          end
        end
      end

      # Emitters that emitt via vlaue pass through
      class PassThrough < self

        handle(Rubinius::AST::FixnumLiteral)
        handle(Rubinius::AST::FloatLiteral)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit(node.value)
        end

      end
    end
  end
end
