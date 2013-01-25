module ToSource
  class Emitter
    class SendWithArguments < Send

      handle(Rubinius::AST::SendWithArguments)

      BINARY_OPERATORS = %w(
        + - * / & | && || << >> == 
        === != <= < <=> > >= =~ !~ ^ 
        **
      ).map(&:to_sym).to_set

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        if element_reference?
          run(ElementReference)
          return
        end
        if binary_operator_method?
          run(BinaryOperatorMethod)
          return
        end
        normal_dispatch
      end
      
      # Test for element reference
      #
      # @return [true]
      #   if node is an element reference
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def element_reference?
        name == :[]
      end

      # Test for binary operator method
      #
      # @return [true]
      #   if node is a binary operator method
      #
      # @return [false]
      #   otherwise
      #
      def binary_operator_method?
        BINARY_OPERATORS.include?(name)
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
        emit_arguments
        emit_block
      end

      # Emit arguments
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_arguments
        emit('(')
        emitter = visit(node.arguments)
        emit_block_pass(emitter)
        emit(')')
      end

      # Emit block pass
      #
      # @param [Class:Emitter] emitter
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_block_pass(emitter)
        return unless block_pass?
        emit(', ') if emitter.any?
        visit(block)
      end

    end
  end
end
