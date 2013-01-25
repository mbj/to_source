module ToSource
  class Emitter
    # base class for utility emitters
    class Util < self
      # Emitter for delimited bodies
      class DelimitedBody < self

      private

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          body = node
          max = body.length - 1
          body.each_with_index do |member, index|
            visit(member)
            emit(', ') if index < max
          end
        end

      end
    end
  end
end
