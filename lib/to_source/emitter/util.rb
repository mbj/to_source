module ToSource
  class Emitter
    class Util < self
      class DelimitedBody < self

      private

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
