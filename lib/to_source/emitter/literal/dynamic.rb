module ToSource
  class Emitter
    class Literal
      class Dynamic < self

      private

        def dispatch
          emit_open
          emit_first
          emit_segments
          emit_close
        end

        def emit_open
          emit(self.class::OPEN)
        end

        def emit_close
          emit(self.class::CLOSE)
        end

        def first_value
          node.string
        end

        def emit_literal(literal)
          emit(literal.inspect[1..-2])
        end
        
        def emit_literal_node(node)
          emit_literal(node.string)
        end

        def emit_first
          emit_literal(first_value)
        end

        def emit_segments
          array.each_with_index do |segment, index|
            emit_segment(segment, index)
          end
        end

        def emit_segment(segment, index)
          case segment
          when Rubinius::AST::StringLiteral
            emit_literal_node(segment)
          else
            visit(segment)
          end
        end

        def array
          node.array
        end

        def max
          array.length - 1
        end
        memoize :max

        class Symbol < self

          handle(Rubinius::AST::DynamicSymbol)

          OPEN = ':"'
          CLOSE = '"'

        end

        class String < self

          handle(Rubinius::AST::DynamicString)

          OPEN = CLOSE = '"'.freeze

        end

        class Execute < self

          handle(Rubinius::AST::DynamicExecuteString)

          OPEN = CLOSE = '`'.freeze

        end

        class Regex < self

          OPEN = CLOSE = '/'.freeze

          handle(Rubinius::AST::DynamicRegex)

          def emit_literal(literal)
            emit(Regexp.new(literal).source)[1..-2]
          end

        end

      end
    end
  end
end
