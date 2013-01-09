module ToSource
  class Emitter
    class SendWithArguments < Send

      handle(Rubinius::AST::SendWithArguments)

    private

      def dispatch
        if node.name == :[]
          run(ElementReference, node)
          return
        end
        if binary_operator_method?
          run(BinaryOperatorMethod, node)
          return
        end
        normal_dispatch
      end

      BINARY_OPERATORS = %w(
        + - * / & | && || << >> == 
        === != <= < <=> > >= =~ !~ ^ 
        **
      ).map(&:to_sym).to_set

      def binary_operator_method?
        BINARY_OPERATORS.include?(node.name)
      end

      def normal_dispatch
        emit_receiver
        emit_name
        emit_arguments
        emit_block
      end

      def emit_arguments
        emit('(')
        emitter = visit(node.arguments)
        emit_block_pass(emitter)
        emit(')')
      end

      def emit_block_pass(emitter)
        return unless block_pass?
        emit(', ') if emitter.any?
        visit(block)
      end

    end
  end
end
