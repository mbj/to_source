module ToSource
  class Emitter
    # Emitter for singleton class nodes
    class SingletonClass < self

      handle(Rubinius::AST::SClass)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('class << ')
        visit(node.receiver)
        emit_body
        emit_end
      end

      # Emit body
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_body
        indented do
          # FIXME: attr_reader missing on Rubinius::AST::SClass
          visit(node.instance_variable_get(:@body))
        end
      end

    end
  end
end
