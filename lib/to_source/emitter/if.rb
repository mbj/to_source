module ToSource
  class Emitter
    # Emitter for if nodes
    class If < self

      handle(Rubinius::AST::If)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        if else_branch? and !if_branch?
          run(Unless, node)
          return
        end

        normal_dispatch
      end

      # Test if if branch is present
      #
      # @return [true]
      #   if if branch is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def if_branch?
        !node.body.kind_of?(Rubinius::AST::NilLiteral)
      end

      # Test if else branch is present
      #
      # @return [true]
      #   if else branch is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def else_branch?
        !node.else.kind_of?(Rubinius::AST::NilLiteral)
      end

      # Perform normal dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def normal_dispatch
        emit('if ')
        visit(node.condition)
        emit_if_branch
        emit_else_branch
        emit('end')
      end

      # Emit if brnach
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_if_branch
        indented do
          visit(node.body)
        end
      end

      # Emit else branch
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_else_branch
        body = node.else
        return unless else_branch?
        emit('else')
        indented do
          visit(body)
        end
      end

    end
  end
end
