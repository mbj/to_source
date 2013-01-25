module ToSource
  class Emitter
    class Assignment

      class ElementDispatcher < Emitter

        handle(Rubinius::AST::ElementAssignment)

      private

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          case node.arguments
          when Rubinius::AST::ActualArguments
            run(Element::Argument)
          when Rubinius::AST::PushActualArguments
            run(Element::Push)
          end
        end

      end

      # Emitter for element assignments
      class Element < self

      private

        delegate(:receiver, :arguments)

        # Emit target
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_target
          visit(receiver)
          emit('[')
          emit_index
          emit(']')
        end

        class Argument < self

        private

          # Return arguments array
          #
          # @return [Array]
          #
          # @api private
          #
          def array
            arguments.array
          end

          # Emit index
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_index
            splat = arguments.splat
            if splat
              visit(splat)
            else
              visit(array[0])
            end
          end

          # Return value
          #
          # @return [Rubinius::AST::Node]
          #   if value is present
          #
          # @return [nil]
          #   otherwise
          #
          def value
            array[1]
          end

        end

        class Push < self

          # Emit index
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_index
            # FIXME: Add reader
            visit(arguments.instance_variable_get(:@arguments))
          end

          # Return value
          #
          # @return [Rubinius::AST::Node]
          #   if value is present
          #
          # @return [nil]
          #   otherwise
          #
          # @api private
          #
          def value
            # FIXME: Add reader
            arguments.instance_variable_get(:@value)
          end

        end

      end
    end
  end
end
