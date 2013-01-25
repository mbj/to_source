module ToSource
  class Emitter
    # Emitter for when nodes
    class When < self

      handle(Rubinius::AST::When)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('when ')
        emit_single
        emit_conditions
        emit_splat
        indent
        visit(node.body)
        unindent
      end

      # Emit single
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_single
        single = node.single
        visit(single) if single
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        splat = node.splat
        return unless splat
        visit(splat)
      end

      # Emit conditions
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_conditions
        conditions = node.conditions 
        return unless conditions
        run(Util::DelimitedBody, conditions.body)
      end

    end
  end
end
