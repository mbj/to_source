module ToSource
  class Emitter
    class UnaryOperatorMethod < Send

      UNARY_MAPPING = {
        :-@ => :-,
        :+@ => :+,
      }.freeze

    private

      def dispatch
        name = node.name
        emit(UNARY_MAPPING.fetch(name, name))
        visit(receiver)
      end

    end
  end
end
