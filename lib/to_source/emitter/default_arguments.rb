module ToSource
  class Emitter
    # Emitter for default arguments
    class DefaultArguments < self

      handle(Rubinius::AST::DefaultArguments)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        run(Util::DelimitedBody, node.arguments)
      end

    end
  end
end
