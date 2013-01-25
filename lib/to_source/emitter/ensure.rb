module ToSource
  class Emitter
    # Emitter for ensure nodes
    class Ensure < self

      handle(Rubinius::AST::Ensure)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_begin
        emit_enusure
      end

      # Emit begin
      #
      # @return [undefined]
      #
      # @api private
      # 
      def emit_begin
        emit(:begin)
        indented do
          visit(node.body)
        end
      end

      # Emit ensure
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_enusure
        emit(:ensure)
        indented do
          visit(node.ensure)
        end
        emit_end
      end

    end
  end
end
