module ToSource
  class Emitter
    # Emitter for class module or singleton class scopes
    class Scope < self

      handle(Rubinius::AST::ClassScope)
      handle(Rubinius::AST::ModuleScope)
      handle(Rubinius::AST::SClassScope)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.body)
      end

    end
  end
end
