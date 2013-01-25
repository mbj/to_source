module ToSource
  # Emitter state
  class State

    # Return last command
    #
    # @return [Command]
    #
    # @api private
    #
    attr_reader :last

    # Return current indentation level
    #
    # @return [Fixnum]
    #
    # @api private
    #
    attr_reader :identation

    # Return buffer
    #
    # @return [Array]
    #
    # @api private
    #
    attr_reader :buffer

    # Initialize object
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize
      @last        = Command::NULL
      @indentation = 0
      @buffer      = []
    end

    # Execute command 
    #
    # @param [Command] command
    #
    # @return [self]
    #
    # @api private
    #
    def execute(command)
      command.run(self)
      @last = command
      self
    end

    # Write string to buffer
    #
    # @param [String] string
    #
    # @return [self]
    #
    # @api private
    #
    def write(string)
      @buffer << string
      self
    end

    # Return source
    #
    # @return [String]
    # 
    # @api private
    #
    def source
      buffer.join('')
    end

    # Push command
    #
    # @param [Command] command
    #
    # @return [self]
    #
    # @api private
    #
    def push(command)
      indent
      write(command.content)
      self
    end
 
    # Indent line if needed
    #
    # @return [self]
    #
    # @api private
    #
    def indent
      return unless blank?
      write(' ' * @indentation)
      self
    end

    # Test for blank line
    #
    # @return [true]
    #   if line is blank
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def blank?
      buffer.last == "\n"
    end

    # Write newline
    #
    # @return [self]
    #
    # @api private
    #
    def new_line
      write("\n")
      self
    end

    # Perform shift by width
    #
    # @param [Fixnum] width
    #
    # @return [self]
    #
    # @api private
    #
    def shift(width)
      @indentation += width
      @indentation = 0 if @indentation < 0
      new_line
    end

  end
end
