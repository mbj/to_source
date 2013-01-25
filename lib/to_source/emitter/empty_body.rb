module ToSource
  class Emitter
    # Emitter for empty body
    class EmptyBody < self

      handle(Rubinius::AST::EmptyBody)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
      end

    end
  end
end
