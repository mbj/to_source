module ToSource
  class Emitter
    # Base class for various assignment nodes
    class Assignment < self

    private

      delegate(:value)
      predicate(:value)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_target
        if value?
          emit_operator
          visit(value)
        end
      end

      # Emit operator
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_operator
        emit(' = ')
      end

      # Emitter for element assignments
      class Element < self

        handle(Rubinius::AST::ElementAssignment)

      private

        delegate(:receiver)

        # Return array
        #
        # @return [Array]
        #
        # @api private
        #
        def array
          node.arguments.array
        end

        # Return index
        #
        # @return [Rubinius::AST::Node]
        #
        # @api private
        #
        def index
          array[0]
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
          array[1]
        end

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def emit_target
          visit(receiver)
          emit('[')
          visit(index)
          emit(']')
        end

      end

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

      delegate(:left, :right)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        parantheses do
          visit(left)
          emit(" #{self.class::SYMBOL} ")
          emit_right
        end
      end

      # Emit right
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_right
        parantheses do
          visit(right.value)
        end
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
