module ToSource
  class Emitter

    # Emitter for various access nodes
    class Access < self

      handle(Rubinius::AST::ConstantAccess)
      handle(Rubinius::AST::InstanceVariableAccess)
      handle(Rubinius::AST::LocalVariableAccess)
      handle(Rubinius::AST::ClassVariableAccess)
      handle(Rubinius::AST::GlobalVariableAccess)
      handle(Rubinius::AST::PatternVariable)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      # 
      def dispatch
        emit(node.name)
      end

    end
  end
end
