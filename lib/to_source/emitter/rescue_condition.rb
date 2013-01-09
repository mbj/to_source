module ToSource
  class Emitter
    class RescueCondition < self

      handle(Rubinius::AST::RescueCondition)

    private

      def dispatch
        emit('rescue')
        emit_conditions
        emit_splat
        emit_assignment
        emit_body
        emit_next
      end

      def emit_body
        indent
        visit(node.body)
        unindent
      end

      def emit_conditions
        conditions = node.conditions || return
        body = conditions.body

        first = body.first
        unless body.one? and first.kind_of?(Rubinius::AST::ConstantAccess) and first.name == :StandardError
          space
          run(Util::DelimitedBody, body)
        end
      end

      def emit_splat
        util = node
        splat = util.splat || return
        emit(',') if util.conditions
        space
        visit(splat)
      end

      def emit_assignment
        assignment = node.assignment || return
        emit(' => ')
        emit(assignment.name)
      end

      def emit_next
        next_rescue = node.next || return
        visit(next_rescue)
      end

    end
  end
end
