module ToSource
  class Emitter
    # Emitter for conditiona attribute assignment
    class OpAssign2 < self

      handle(Rubinius::AST::OpAssign2)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        util = node
        visit(util.receiver)
        emit('.')
        emit(util.name)
        emit(" #{operator} ")
        visit(util.value)
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
