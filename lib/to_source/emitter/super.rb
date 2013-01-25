module ToSource
  class Emitter
    # emitter for super node
    class Super < self

      handle(Rubinius::AST::Super)

    private

      delegate(:block)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('super')
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

      # Test for block presence
      #
      # @return [true]
      #   if block is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def block?
        !!block
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
        block.kind_of?(Rubinius::AST::BlockPass19)
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
        return unless block? and block_pass?
        emit(', ') if emitter.any?
        visit(block)
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

    end
  end
end
