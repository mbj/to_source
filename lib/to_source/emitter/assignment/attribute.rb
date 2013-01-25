module ToSource
  class Emitter
    class Assignment
      # Emitter for attribute assignments
      class Attribute < self

        handle(Rubinius::AST::AttributeAssignment)

      private

        delegate(:receiver)

        # Return name
        #
        # @return [Symbol]
        #
        # @api private
        #
        def name
          node.name.to_s.gsub(/=\z/,'').to_sym
        end

        # Emit target
        #
        # @return [self]
        #
        # @api private
        #
        def emit_target
          visit(receiver)
          emit('.')
          emit(name)
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
          node.arguments.array.first
        end

      end
    end
  end
end
