module ToSource
  class Emitter
    class Literal < self

      class EmptyArray < self

        handle(Rubinius::AST::EmptyArray)

        def dispatch
          emit('[]')
        end
      end

      class Array < self

        handle(Rubinius::AST::ArrayLiteral)

      private

        def dispatch
          emit('[')
          run(Util::DelimitedBody, node.body)
          emit(']')
        end
      end

      class Range < self

      private

        def dispatch
          visit(node.start)
          emit(token)
          visit(node.finish)
        end

        def token
          self.class::TOKEN
        end

        class Inclusive < self
          handle(Rubinius::AST::Range)
          TOKEN = '..'
        end

        class Exclude < self
          handle(Rubinius::AST::RangeExclude)
          TOKEN = '...'
        end

      end

      class Hash < self

        handle(Rubinius::AST::HashLiteral)

        def dispatch
          body = node.array.each_slice(2).to_a

          max = body.length - 1

          emit '{'

          body.each_with_index do |slice, index|
            key, value = slice

            visit(key)
            emit ' => '
            visit(value)

            if index < max 
              emit ', ' 
            end
          end

          emit '}'
        end

      end

      class Inspect < self

        handle(Rubinius::AST::SymbolLiteral)

        def dispatch
          emit(value.inspect)
        end

        def value
          node.value
        end

        class Static < self
          def value
            self.class::VALUE
          end

          class True < self
            handle(Rubinius::AST::TrueLiteral)
            VALUE = true
          end

          class False < self
            handle(Rubinius::AST::FalseLiteral)
            VALUE = false
          end

          class Nil < self
            handle(Rubinius::AST::NilLiteral)
            VALUE = nil
          end
        end

        class Regexp < self

          handle(Rubinius::AST::RegexLiteral)

          def value
            ::Regexp.new(node.source)
          end
        end

        class String < self

          handle(Rubinius::AST::StringLiteral)

          def value
            node.string
          end
        end
      end


      class PassThrough < self

        handle(Rubinius::AST::FixnumLiteral)
        handle(Rubinius::AST::FloatLiteral)

        def dispatch
          emit(node.value)
        end

      end
    end
  end
end
