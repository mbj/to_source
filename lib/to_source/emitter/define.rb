module ToSource
  class Emitter

    # Emitter for define singleton nodes
    class DefineSingleton < self

      handle(Rubinius::AST::DefineSingleton)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('def ')
        visit(node.receiver)
        emit('.')
        visit(node.body)
      end
    end

    # Base class for define emitters
    class Define < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def shared_dispatch
        emit(node.name)
        emit_arguments
        indent
        visit(node.body)
        unindent
        emit_end
      end

      # Emit arguments
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_arguments
        run(FormalArguments::Method)
      end

      # Emitter for singeton level defines
      class Singleton < self

        handle(Rubinius::AST::DefineSingletonScope)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          shared_dispatch
        end

      end

      # Emitter for instance level defines
      class Instance < self

        handle(Rubinius::AST::Define)

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit('def ')
          shared_dispatch
        end

      end
    end
  end
end
