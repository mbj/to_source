module ToSource
  class Emitter
    class Literal
      # Emitter for regexp literal nodes
      class Regexp < self

        handle(Rubinius::AST::RegexLiteral)

      private

        delegate(:options)

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit("/#{node.source}/")
          run(Options, options)
        end

      end
    end
  end
end
