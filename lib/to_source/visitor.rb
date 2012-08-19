module ToSource
  # Converter from AST to source
  class Visitor

    # Create source code from AST node
    #
    # @param [Rubinius::AST::Node] node
    #   the node to convert to source code
    #
    # @return [String]
    #   returns the source code for ast node
    #
    def self.run(node)
      new(node).output
    end

    # Return the source code of AST
    #
    # @return [String]
    #
    # @api private
    #
    def output
      @output.join
    end

  private

    # Initialize visitor
    # 
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(node)
      @output = []
      @indentation = 0
      dispatch(node)
    end

    # Dispatch node
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def dispatch(node)
      name = node.node_name
      name = "#{name}_def" if %w[ class module ].include?(name)
      __send__(name, node)
    end

    # Emit body with taking care on indentation
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def body(node)
      @indentation+=1
      node = 
        case node
        when Rubinius::AST::Block, Rubinius::AST::EmptyBody
          node
        else
          Rubinius::AST::Block.new(node.line, [node])
        end

      dispatch(node)
      nl
    ensure
      @indentation-=1
    end

    # Emit end keyword
    #
    # @return [undefined]
    #
    # @api private
    #
    def kend
      emit(current_indentation)
      emit('end')
    end

    # Emit newline
    #
    # @return [undefined]
    #
    # @api private
    #
    def nl
      emit("\n")
    end

    # Emit pice of code
    #
    # @param [String] code
    #
    # @return [undefined]
    #
    # @api private
    #
    def emit(code)
      @output << code
    end

    # Return current indentation
    #
    # @return [String]
    #
    # @api private
    #
    def current_indentation
      '  ' * @indentation
    end

    # Emit to array
    #
    # @param [Rubinius::AST::Node] node
    #
    # @api private
    #
    def to_array(node)
      dispatch(node.value)
    end

    # Emit multiple assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def multiple_assignment(node)
      body = node.left.body

      array_body(node.left.body)

      emit(' = ')

      right = node.right

      if node.right.kind_of?(Rubinius::AST::ArrayLiteral)
        array_body(right.body)
      else
        dispatch(right)
      end
    end

    # Emit constant assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def constant_assignment(node)
      dispatch(node.constant)
      emit(' = ')
      dispatch(node.value)
    end

    # Emit negation
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def negate(node)
      emit('-')
      dispatch(node.value)
    end

    # Emit class definition
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def class_def(node)
      emit('class ')

      dispatch(node.name)

      superclass = node.superclass
      unless superclass.is_a?(Rubinius::AST::NilLiteral)
        emit ' < '
        dispatch(superclass)
      end
      nl

      dispatch(node.body)

      kend
    end

    # Emit class name
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def class_name(node)
      emit(node.name)
    end

    # Emit module name
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def module_name(node)
      emit(node.name)
    end

    # Emit module definition
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def module_def(node)
      emit "module "
      dispatch(node.name)
      nl

      dispatch(node.body)

      kend
    end

    # Emit empty body
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def empty_body(*)
      # do nothing
    end

    # Emit class scope
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def class_scope(node)
      body(node.body)
    end

    # Emit module scope
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def module_scope(node)
      body(node.body)
    end

    # Emit local variable assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def local_variable_assignment(node)
      if node.value
        emit("#{node.name} = ")
        dispatch(node.value)
      else
        emit(node.name)
      end
    end

    # Emit local variable access
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def local_variable_access(node)
      emit(node.name)
    end

    # Emit instance variable assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def instance_variable_assignment(node)
      if(node.value)
        emit("%s = " % node.name)
        dispatch(node.value)
      else
        emit(node.name)
      end
    end

    # Emit instance variable access
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def instance_variable_access(node)
      emit(node.name)
    end

    # Emit fixnum literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def fixnum_literal(node)
      emit(node.value.to_s)
    end

    # Emit float literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def float_literal(node)
      emit(node.value.to_s)
    end

    # Emit string literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def string_literal(node)
      emit(node.string.inspect)
    end

    # Emit symbol literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def symbol_literal(node)
      emit ":#{node.value.to_s}"
    end

    # Emit true literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def true_literal(node)
      emit 'true'
    end

    # Emit false literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def false_literal(node)
      emit 'false'
    end

    # Emit nil literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def nil_literal(node)
      emit 'nil'
    end

    # Emit array body
    #
    # @param [Array]
    #
    # @return [undefined]
    #
    # @api private
    #
    def array_body(body)
      body.each_with_index do |node, index|
        dispatch(node)
        emit ', ' unless body.length == index + 1 # last element
      end
    end

    # Emit array literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def array_literal(node)
      emit('[')
      array_body(node.body)
      emit(']')
    end

    # Emit hash literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def hash_literal(node)
      body = node.array.each_slice(2)

      emit '{'
      body.each_with_index do |slice, index|
        key, value = slice

        dispatch(key)
        emit " => "
        dispatch(value)

        emit ', ' unless body.to_a.length == index + 1 # last element
      end
      emit '}'
    end

    # Emit inclusive range literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def range(node)
      dispatch(node.start)
      emit '..'
      dispatch(node.finish)
    end

    # Emit exlusive range literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def range_exclude(node)
      dispatch(node.start)
      emit '...'
      dispatch(node.finish)
    end

    # Emit range literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def regex_literal(node)
      emit '/'
      emit node.source
      emit '/'
    end

    # Emit send literal
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def send(node)
      if node.name == :'!'
        emit('!')
        dispatch(node.receiver)
        return
      end

      unless node.receiver.is_a?(Rubinius::AST::Self) and node.privately
        dispatch(node.receiver)
        emit('.')
      end

      emit(node.name)

      block = node.block

      if(block)
        if block.kind_of?(Rubinius::AST::BlockPass)
          emit('(')
          block_pass(block)
          emit(')')
        else
          iter(block)
        end
      end
    end

    # Emit self 
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def self(node)
      emit 'self'
    end


    # Emit send with arguments 
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def send_with_arguments(node)
      return if process_binary_operator(node) # 1 * 2, a / 3, true && false

      unless node.receiver.is_a?(Rubinius::AST::Self)
        dispatch(node.receiver)
        emit('.')
      end

      emit(node.name)

      emit('(')
      actual_arguments(node.arguments)

      block = node.block

      is_block_pass = block.kind_of?(Rubinius::AST::BlockPass)

      if is_block_pass
        emit(', ')
        block_pass(block)
      end

      emit(')')

      if block and !is_block_pass
        emit(' ')
        dispatch(node.block) 
      end
    end

    # Emit acutal arguments
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def actual_arguments(node)
      body = node.array
      body.each_with_index do |argument, index|
        dispatch(argument)
        emit(', ') unless body.length == index + 1 # last element
      end
    end

    # Emit iteration
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def iter(node)
      emit(' do')

      arguments = node.arguments
      unless arguments.names.empty?
        emit(' ')
        iter_arguments(node.arguments)
      end

      nl
      body(node.body)

      kend
    end

    # Emit iteration arguments for ruby18 mode
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def iter_arguments(node)
      body = if node.prelude == :single
        Array(node.arguments.name)
      else
        node.arguments.left.body.map(&:name)
      end

      emit '|'
      body.each_with_index do |argument, index|
        emit argument.to_s
        emit ', ' unless body.length == index + 1 # last element
      end
      emit '|'
    end

    # Emit iteration arguments for ruby19 mode
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def iter19(node)
      emit('do')

      arguments = node.arguments
      unless arguments.names.empty?
        emit(' ')
        formal_arguments_generic(node.arguments,'|','|')
      end

      nl
      body(node.body)

      kend
    end

    # Emit block
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def block(node)
      body = node.array
      body.each_with_index do |expression,index|
        emit(current_indentation)
        dispatch(expression)
        nl unless body.length == index+1
      end
    end

    # Emit not
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def not(node)
      emit('!')
      dispatch(node.value)
    end

    # Emit and
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def and(node)
      dispatch(node.left)
      emit(' && ')
      dispatch(node.right)
    end

    # Emit or
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def or(node)
      dispatch(node.left)
      emit(' || ')
      dispatch(node.right)
    end

    # Emit and operation with assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def op_assign_and(node)
      dispatch(node.left)
      emit(' && ')
      dispatch(node.right)
    end

    # Emit or operation with assignment
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def op_assign_or(node)
      dispatch(node.left)
      emit(' || ')
      dispatch(node.right)
    end
    alias_method :op_assign_or19, :op_assign_or

    # Emit toplevel constant 
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def toplevel_constant(node)
      emit('::')
      emit(node.name)
    end

    # Emit constant accesws
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def constant_access(node)
      emit(node.name)
    end

    # Emit scoped constant
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def scoped_constant(node)
      dispatch(node.parent)
      emit('::')
      emit(node.name)
    end
    alias_method :scoped_class_name, :scoped_constant
    alias_method :scoped_module_name, :scoped_constant

    # Emit if expression
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def if(node)
      body, else_body = node.body, node.else

      keyword = 'if'

      if node.body.is_a?(Rubinius::AST::NilLiteral) && !node.else.is_a?(Rubinius::AST::NilLiteral)
        body, else_body = else_body, body
        keyword = 'unless'
      end

      emit(keyword)
      emit(' ')
      dispatch(node.condition)
      nl

      body(body)

      if else_body.is_a?(Rubinius::AST::NilLiteral)
        kend
        return
      end

      emit('else')
      nl

      body(else_body)

      kend
    end

    # Dispatch node
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def while(node)
      emit 'while '
      dispatch(node.condition)
      nl

      body(node.body)

      kend
    end

    # Emit until
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def until(node)
      emit 'until '
      dispatch(node.condition)
      nl

      body(node.body)

      kend
    end

    # Emit formal arguments as shared between ruby18 and ruby19 mode
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def formal_arguments_generic(node,open,close)
      return if node.names.empty? 
      required, defaults, splat = node.required, node.defaults, node.splat

      emit(open)
      emit(required.join(', '))

      empty = required.empty?

      if defaults
        emit(', ') unless empty
        dispatch(node.defaults)
      end

      if node.splat
        emit(', ') unless empty
        emit('*')
        emit(node.splat)
      end

      if node.block_arg
        emit(', ') unless empty

        dispatch(node.block_arg)
      end

      emit(close)
    end

    # Emit formal arguments for ruby19 and ruby18
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def formal_arguments(node)
      formal_arguments_generic(node,'(',')')
    end
    alias_method :formal_arguments19, :formal_arguments

    # Emit block argument
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def block_argument(node)
      emit('&')
      emit(node.name)
    end

    # Emit default arguments
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def default_arguments(node)
      last = node.arguments.length - 1
      node.arguments.each_with_index do |argument, index|
        dispatch(argument)
        emit(',') unless index == last
      end
    end

    # Emit define on instances
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def define(node)
      emit('def ')

      emit(node.name)
      dispatch(node.arguments)
      nl

      body(node.body)
      kend
    end

    # Emit define on singletons
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def define_singleton(node)
      emit('def ')
      dispatch(node.receiver)
      emit('.')
      dispatch(node.body)
    end

    # Emit singleton scope
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def define_singleton_scope(node)
      emit(node.name)
      dispatch(node.arguments)
      nl
      
      body(node.body)

      kend
    end

    # Emit block pass 
    #
    # @param [Rubinius::AST::Node] nod
    #
    # @return [undefined]
    #
    # @api private
    #
    def block_pass(node)
      emit('&')
      dispatch(node.body)
    end

    # Emit return statement
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def return(node)
      emit('return')
      if node.value
        emit(' ')
        dispatch(node.value)
      end
    end

    # Process binary operator
    #
    # @param [Rubinius::AST::Node] node
    #
    # @return [undefined]
    #
    # @api private
    #
    def process_binary_operator(node)
      operators = %w(+ - * / & | <<).map(&:to_sym)
      return false unless operators.include?(node.name)
      return false if node.arguments.array.length != 1

      operand = node.arguments.array[0]

      unless node.receiver.is_a?(Rubinius::AST::Self)
        dispatch(node.receiver)
      end

      emit(" #{node.name.to_s} ")
      dispatch(operand)
    end
  end
end
