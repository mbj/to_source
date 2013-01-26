module ToSource
  class Emitter
    class VAlias < self

      handle(Rubinius::AST::VAlias)

    private

      delegate(:to, :from)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('alias ')
        emit(to)
        space
        emit(from)
      end

    end

    # Emiter for alias node
    class Alias < self

      handle(Rubinius::AST::Alias)

    private

      delegate(:to, :from)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('alias ')
        emit(to.value)
        space
        emit(from.value)
      end

    end
  end
end
