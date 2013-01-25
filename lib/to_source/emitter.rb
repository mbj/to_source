module ToSource
  # Abstract base class for emitter
  class Emitter
    include Adamantium::Flat, Equalizer.new(:node)

    # The emitter registry
    REGISTRY = {}

    # Build emitter for node
    #
    # @param [Rubinius::AST::Node] node
    # @param [Array] buffer
    #
    # @return [Emitter]
    #
    # @api private
    #
    def self.build(node, buffer = [])
      REGISTRY.fetch(node.class).new(node, buffer)
    end

    # Run emitter for node
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [String]
    #
    # @api private
    #
    def self.run(node)
      build(node).source
    end

    # Declare node delegators
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.delegate(*names)
      names.each do |name|
        define_delegator(name)
      end
    end

    private_class_method :delegate

    # Register emitter for node class
    #
    # @param [Class:Rubinius::AST::Node] node_class
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.handle(node_class)
      REGISTRY[node_class]=self
    end

    private_class_method :handle

    # Define node delegator
    #
    # @param [Symbol] name
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.define_delegator(name)
      define_method(name) do
        node.public_send(name)
      end
      private(name)
    end

    private_class_method :define_delegator

    # Return buffer
    #
    # @return [Array<Command>]
    #
    # @api private
    #
    attr_reader :buffer

    # Return node
    #
    # @return [Rubinius::AST::Node]
    #
    # @api private
    # 
    attr_reader :node

    # Initialize object
    #
    # @param [Rubinius::AST::Node] node
    # @param [Array<Command>] buffer
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(node, buffer)
      @node, @buffer = node, buffer
      dispatch
    end

    # Return source
    #
    # @return [String]
    #
    # @api private
    #
    def source
      state = State.new
      buffer.each do |command|
        state.execute(command)
      end
      state.source
    end

  private

    # Push command
    #
    # @param [Command] command
    #
    # @return [undefined]
    #
    # @api private
    # 
    def push(command)
      buffer.push(command)
    end

    # Emit new line
    #
    # @return [undefined]
    #
    # @api private
    #
    def new_line
      emit("\n")
    end

    # Emit single whitespace
    #
    # @return [undefined]
    #
    # @api private
    #
    def space
      emit(' ')
    end

    # Emit end keyword
    #
    # @return [undefined]
    #
    # @api private
    #
    def emit_end
      emit(:end)
    end

    # Push indent command
    #
    # @return [undefined]
    #
    # @api private
    #
    def indent
      push(Command::Shift::INDENT)
    end

    # Push unindent command
    #
    # @return [undefined]
    #
    # @api private
    #
    def unindent
      push(Command::Shift::UNINDENT)
    end

    # Push token with content
    #
    # @param [String] content
    #
    # @return [undefined]
    #
    # @api private
    #
    def emit(content)
      push(Command::Token.new(content))
    end

    # Visit descendant node
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def visit(node)
      self.class.build(node, buffer)
    end

    # Run emitter on buffer
    #
    # @param [Class:Emitter] emitter
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def run(emitter, node = self.node)
      emitter.new(node, buffer)
    end
  end
end
