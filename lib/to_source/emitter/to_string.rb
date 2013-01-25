module ToSource
  class Emitter
    # Emit to string node
    class ToString < self

      handle(Rubinius::AST::ToString)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('#{')
        visit(node.value)
        emit('}')
      end

    end
  end
end
