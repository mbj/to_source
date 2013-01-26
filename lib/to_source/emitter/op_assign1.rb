module ToSource
  class Emitter
    # Emitter for conditiona element assignment
    class OpAssign1 < self

      handle(Rubinius::AST::OpAssign1)

    private

      delegate(:receiver, :arguments, :value)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(receiver)
        emit('[')
        visit(arguments.array.first)
        emit("] #{operator} ")
        visit(value)
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
