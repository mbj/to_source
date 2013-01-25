module ToSource
  class Emitter
    # Emitter for execute string
    class ExecuteString < self

      handle(Rubinius::AST::ExecuteString)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit("`#{node.string}`")
      end

    end
  end
end
