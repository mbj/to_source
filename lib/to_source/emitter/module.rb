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
        indented do
          visit(util.body)
        end
        emit_end
      end

    end
  end
end
