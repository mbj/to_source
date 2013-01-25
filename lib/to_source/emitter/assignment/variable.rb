module ToSource
  class Emitter
    class Assignment
      # Emitter for various variabe assignments
      class Variable < self

        handle(Rubinius::AST::LocalVariableAssignment)
        handle(Rubinius::AST::InstanceVariableAssignment)
        handle(Rubinius::AST::GlobalVariableAssignment)
        handle(Rubinius::AST::ClassVariableAssignment)

      private

        delegate(:value)

        # Emit target
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_target
          emit(node.name)
        end

      end
    end
  end
end
