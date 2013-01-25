module ToSource
  class Emitter
    class Literal
      # Base class for dynamic literal emitters
      class Dynamic < self

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit_open
          emit_first
          emit_segments
          emit_close
        end

        # Emit open
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_open
          emit(self.class::OPEN)
        end

        # Emit close
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_close
          emit(self.class::CLOSE)
        end

        # Return first value
        #
        # @return [String]
        #
        # @api private
        #
        def first_value
          node.string
        end

        # Emit literal
        #
        # @param [Object] literal
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_literal(literal)
          emit(literal.inspect[1..-2])
        end
        
        # Emit literal node
        #
        # @param [Rubinius::AST::Node] node
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_literal_node(node)
          emit_literal(node.string)
        end

        # Emit first
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_first
          emit_literal(first_value)
        end

        # Emit segments
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_segments
          array.each do |segment|
            emit_segment(segment)
          end
        end

        # Emit segment
        #
        # @param [Rubinius::AST::Node] segment
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_segment(segment)
          case segment
          when Rubinius::AST::StringLiteral
            emit_literal_node(segment)
          else
            visit(segment)
          end
        end

        delegate :array

        # Return max segment number
        #
        # @return [Fixnum]
        #
        # @api private
        #
        def max
          array.length - 1
        end
        memoize :max

        # Emitter for dynamic symbol literals
        class Symbol < self

          handle(Rubinius::AST::DynamicSymbol)
          OPEN = ':"'.freeze
          CLOSE = '"'.freeze

        end

        # Emitter for dynamic string literals
        class String < self

          handle(Rubinius::AST::DynamicString)
          OPEN = CLOSE = '"'.freeze

        end

        # Emitter for dynamic execute string literals
        class Execute < self

          handle(Rubinius::AST::DynamicExecuteString)
          OPEN = CLOSE = '`'.freeze

        end

        # Emitter for dynamic regexp literals
        class Regex < self

          handle(Rubinius::AST::DynamicRegex)
          OPEN = CLOSE = '/'.freeze

        private

          # Emit literal
          #
          # @param [String] literal
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_literal(literal)
            emit(literal)
          end

        end

      end
    end
  end
end
