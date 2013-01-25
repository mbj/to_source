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
        indent
        visit(util.body)
        unindent
        visit(util.rescue)
        emit_end
      end

    end
  end
end
