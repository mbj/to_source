module ToSource
  class Emitter
    class Literal
      class Dynamic

        # Emitter for dynamic regexp literals
        class Regex < self

          handle(Rubinius::AST::DynamicRegex)
          OPEN = CLOSE = '/'.freeze

        private

          # Perform dispatch
          #
          # @return [undefined]
          #
          # @api private
          #
          def dispatch
            super
            emit_flags
          end

          # Emit flags
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_flags
            run(Literal::Regexp::Options, node.options)
          end

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

          class Once < self

            handle(Rubinius::AST::DynamicOnceRegex)

          private

            # Emit flags
            #
            # @return [undefined]
            #
            # @api private
            #
            def emit_flags
              emit('o')
              super
            end

          end
        end
      end
    end
  end
end
