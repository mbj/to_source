module ToSource
  class Emitter
    # Emiter for alias node
    class Alias < self

      handle(Rubinius::AST::Alias)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('alias ')
        emit(node.to.value)
        space
        emit(node.from.value)
      end

    end
  end
end
