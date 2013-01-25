module ToSource
  class Emitter
    # Base class for various assignment nodes
    class Assignment < self

    private

      delegate :value

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_target
        val = value

        if val
          emit(' = ')
          visit(val)
        end
      end

      # Emitter for constant assignments
      class Constant < self

        handle(Rubinius::AST::ConstantAssignment)

      private

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

      # Emitter for various variabe assignments
      class Variable < self

        handle(Rubinius::AST::LocalVariableAssignment)
        handle(Rubinius::AST::InstanceVariableAssignment)
        handle(Rubinius::AST::GlobalVariableAssignment)
        handle(Rubinius::AST::ClassVariableAssignment)

      private

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

    # Base class for assignment operators
    class AssignmentOperator < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('(')
        visit(node.left)
        space
        emit(self.class::SYMBOL)
        space
        emit('(')
        visit(node.right.value)
        emit(')')
        emit(')')
      end

      # Emitter for or assigmnent operator
      class Or < self

        handle(Rubinius::AST::OpAssignOr19)
        SYMBOL = :'||='

      end

      # Emitter for and assigmnent operator
      class And < self

        handle(Rubinius::AST::OpAssignAnd)
        SYMBOL = :'&&='

      end

    end
  end
end
