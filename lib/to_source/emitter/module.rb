module ToSource
  class Emitter
    # Emitter for module nodes
    class Module < self

      handle(Rubinius::AST::Module)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        util = node
        emit('module ')
        visit(util.name)
        indent
        visit(util.body)
        unindent
        emit_end
      end

    end
  end
end
