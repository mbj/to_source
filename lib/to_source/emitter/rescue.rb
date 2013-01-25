module ToSource
  class Emitter
    # Emitter for rescue nodes
    class Rescue < self

      handle(Rubinius::AST::Rescue)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        util = node
        emit('begin')
        indented do
          visit(util.body)
        end
        visit(util.rescue)
        emit_end
      end

    end
  end
end
