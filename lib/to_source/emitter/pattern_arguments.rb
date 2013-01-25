module ToSource
  class Emitter
    # Emitter for pattern argument node
    class PatternArguments < self

      handle(Rubinius::AST::PatternArguments)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('(')
        run(Util::DelimitedBody, node.arguments.body)
        emit(')')
      end

    end
  end
end
