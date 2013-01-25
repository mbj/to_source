module ToSource
  class Emitter
    # Emitter for unary operator method
    class UnaryOperatorMethod < Send

      UNARY_MAPPING = {
        :-@ => :-,
        :+@ => :+,
      }.freeze

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        name = node.name
        emit(UNARY_MAPPING.fetch(name, name))
        visit(receiver)
      end

    end
  end
end
