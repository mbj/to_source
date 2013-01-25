module ToSource
  class Emitter

    class Splat < self
      handle(Rubinius::AST::SplatArray)
      handle(Rubinius::AST::SplatAssignment)
      handle(Rubinius::AST::SplatWrapped)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('*')
        visit(node.value)
      end
    end

    # Emitter for multiple assignment nodes
    class MultipleAssignment < self

      handle(Rubinius::AST::MultipleAssignment)

    private

      delegate(:right, :splat, :left)
      predicate(:right, :splat, :left)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_left
        emit_splat
        if right?
          emit(' = ')
          emit_right 
        end
      end

      # Emit left
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_left
        return unless left?
        run(Util::DelimitedBody, left.body)
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        return unless splat?
        emit(', ') if left?
        visit(splat)
      end

      # Emit right
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_right
        return unless right?
        right = node.right
        if right.kind_of?(Rubinius::AST::ArrayLiteral)
          run(Util::DelimitedBody, right.body)
        else
          visit(right)
        end
      end

    end
  end
end
