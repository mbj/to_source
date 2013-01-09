module ToSource
  class Emitter
    class Send < self

      handle(Rubinius::AST::Send)

      UNARY_OPERATORS = %w(
        ! ~ -@ +@
      ).map(&:to_sym).to_set.freeze

    private

      def unary_operator_method?
        UNARY_OPERATORS.include?(node.name)
      end

      def dispatch
        if unary_operator_method?
          run(UnaryOperatorMethod, node)
          return
        end

        normal_dispatch
      end

      def normal_dispatch
        emit_receiver
        emit_name
        emit_block_pass
        emit_block
      end

      def block?
        !!block
      end

      def block
        node.block
      end

      def block_pass?
        block? && block.kind_of?(Rubinius::AST::BlockPass19)
      end

      def emit_name
        emit(node.name)
      end

      def emit_receiver
        return if node.privately
        visit(node.receiver)
        emit('.')
      end

      def emit_block
        return unless block? and !block_pass?
        visit(block)
      end

      def emit_block_pass
        return unless block_pass?
        emit('(')
        visit(block)
        emit(')')
      end

    end
  end
end
