module ToSource
  class Emitter
    class Send < self

      handle(Rubinius::AST::Send)

      UNARY_OPERATORS = %w(
        ! ~ -@ +@
      ).map(&:to_sym).to_set.freeze

    private

      delegate(:block, :name, :receiver)
      predicate(:block)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        case
        when unary_operator_method?
          run(UnaryOperatorMethod)
          return
        when for?
          run(For)
          return
        end

        normal_dispatch
      end

      # Test for for node
      #
      # @return [true]
      #   if for node is detected
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def for?
        block.kind_of?(Rubinius::AST::For19)
      end

      # Test for unary operator method
      #
      # @return [true]
      #   if node is an unary operator method
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def unary_operator_method?
        UNARY_OPERATORS.include?(name)
      end

      # Perform normal dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def normal_dispatch
        emit_receiver
        emit_name
        emit_block_pass
        emit_block
      end

      # Test for block pass
      #
      # @return [true]
      #   if block pass is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def block_pass?
        block? && block.kind_of?(Rubinius::AST::BlockPass19)
      end

      # Emit name
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_name
        emit(name)
      end

      # Emit receiver
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_receiver
        return if node.privately
        visit(receiver)
        emit('.')
      end

      # Emit block
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_block
        return unless block? and !block_pass?
        visit(block)
      end

      # Emit block pass
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_block_pass
        return unless block_pass?
        emit('(')
        visit(block)
        emit(')')
      end

    end
  end
end
