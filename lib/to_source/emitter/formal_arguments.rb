module ToSource
  class Emitter
    # Emitter for formal arguments
    class FormalArguments < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        return unless any?
        util = self.class
        emit(util::OPEN)
        emit_required
        emit_defaults
        emit_splat
        emit_block_arg
        emit(util::CLOSE)
      end

      # Test if any argument is present
      #
      # @return [true]
      #   if any argument is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def any?
        required? || defaults? || splat? || block_arg?
      end

      delegate :arguments

      # Return required
      #
      # @return [Array]
      #
      # @api private
      #
      def required
        arguments.required
      end

      # Test if any required arguments are present
      #
      # @return [true]
      #   if any required arguments are presnet
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def required?
        required.any?
      end

      # Return defaults
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def defaults
        arguments.defaults
      end

      # Test if defaults are present
      #
      # @return [true]
      #   if defaults are present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def defaults?
        !!defaults
      end

      # Return splat arguments
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def splat
        arguments.splat
      end

      # Test if splat arguments are present
      #
      # @return [true]
      #   if splat arguments are present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def splat?
        !!splat
      end

      # Return block argument
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def block_arg
        arguments.block_arg
      end

      # Test if block argument is presnet
      #
      # @return [true]
      #   if block argument is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def block_arg?
        !!block_arg
      end

      # Emit required
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_required
        array = required
        max = array.length - 1
        array.each_with_index do |member, index|
          emit_member(member)
          emit(', ') if index < max
        end
      end

      # Emit member
      #
      # @param [Object, Rubinius::AST::Node] member
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_member(member)
        if member.kind_of?(Rubinius::AST::Node)
          visit(member)
        else
          emit(member)
        end
      end

      # Emit defaults
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_defaults
        return unless defaults?
        emit(', ') if required?
        visit(defaults)
      end

      # Emit splat
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        return unless splat?

        emit(', ') if required? or defaults?
        emit('*')
        emit_splat_value(splat)
      end

      # Emit splat value
      #
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat_value(value)
        unless value == :@unnamed_splat
          emit(value)
        end
      end

      # Emit block arg
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_block_arg
        return unless block_arg?
        emit(', ') if required? or defaults? or splat?
        visit(block_arg)
      end

      # Emmiter for block arguments
      class Block < self
        OPEN = ' |'.freeze
        CLOSE = '|'.freeze
      end

      # Emitter for method arguments
      class Method < self
        OPEN = '('.freeze
        CLOSE = ')'.freeze

        # Generic emitter for method arguments
        class Generic < self

          handle(Rubinius::AST::FormalArguments19)

        private

          # Return arguments
          #
          # @return [Rubnius::AST::Node]
          #
          # @api private
          #
          def arguments
            node
          end

        end

      end
    end
  end
end
