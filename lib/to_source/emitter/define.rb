module ToSource
  class Emitter

    # Emitter for define singleton nodes
    class DefineSingleton < self

      handle(Rubinius::AST::DefineSingleton)

    private

      delegate(:receiver, :body)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('def ')
        visit(receiver)
        emit('.')
        visit(body)
      end
    end

    # Base class for define emitters
    class Define < self

    private

      delegate(:name, :body)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def shared_dispatch
        emit(name)
        emit_arguments
        indented do
          visit(body)
        end
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
