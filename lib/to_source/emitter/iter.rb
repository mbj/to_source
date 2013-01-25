module ToSource
  class Emitter
    # Emitter for iter nodes
    class Iter < self

      handle(Rubinius::AST::Iter19)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(' do')
        run(FormalArguments::Block)
        indented do
          visit(node.body)
        end
        emit_end
      end

    end
  end
end
