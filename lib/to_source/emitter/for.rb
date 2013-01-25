module ToSource
  class Emitter
    class ForArguments < self

      handle(Rubinius::AST::For19Arguments)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(arguments)
      end

      # Return arguments
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def arguments
        # FIXME: Add accessor
        node.instance_variable_get(:@arguments)
      end

    end

    class For < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('for ')
        visit(node.block.arguments)
        emit(' in ')
        emit_receiver
        visit(node.block)
      end

      # Emit receiver
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_receiver
        return if node.privately
        visit(node.receiver)
      end

    end

    class For19 < self

      handle(Rubinius::AST::For19)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(' do')
        indented do
          visit(node.body)
        end
        emit_end
      end

    end
  end
end

