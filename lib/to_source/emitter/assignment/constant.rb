module ToSource
  class Emitter
    class Assignment
      # Emitter for constant assignments
      class Constant < self

        handle(Rubinius::AST::ConstantAssignment)

      private

        delegate(:value)

        # Emit name
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_target
          visit(node.constant)
        end

      end
    end
  end
end
