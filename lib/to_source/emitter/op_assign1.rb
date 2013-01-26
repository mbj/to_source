module ToSource
  class Emitter
    # Emitter for conditiona element assignment
    class OpAssign1 < self

      handle(Rubinius::AST::OpAssign1)

    private

      delegate(:receiver, :value)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(receiver)
        emit('[')
        emit_index
        emit("] #{operator} ")
        visit(value)
      end

      # Emit index
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_index
        arguments = node.arguments
        array = arguments.array
        if array.any?
          visit(array.first)
          return
        end
      end

      MAPPING = {
        :or =>  :'||',
        :and => :'&&'
      }.freeze

      # Return operator
      #
      # @return [String]
      #
      # @api private
      #
      def operator
        op = node.op
        "#{MAPPING.fetch(op, op)}="
      end

    end
  end
end
