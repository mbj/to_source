module ToSource
  class Emitter
    # Emitter for rescue condition within rescue nodes
    class RescueCondition < self

      handle(Rubinius::AST::RescueCondition)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('rescue')
        emit_conditions
        emit_splat
        emit_assignment
        emit_body
        emit_next
      end

      # Emit body
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_body
        indented do
          visit(node.body)
        end
      end

      # Emit conditions
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_conditions
        conditions = node.conditions || return
        body = conditions.body

        first = body.first
        unless body.one? and first.kind_of?(Rubinius::AST::ConstantAccess) and first.name == :StandardError
          space
          run(Util::DelimitedBody, body)
        end
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        util = node
        splat = util.splat || return
        emit(',') if util.conditions
        space
        visit(splat)
      end

      # Emit assignment
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_assignment
        assignment = node.assignment || return
        emit(' => ')
        emit(assignment.name)
      end

      # Emit next
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_next
        next_rescue = node.next || return
        visit(next_rescue)
      end

    end
  end
end
