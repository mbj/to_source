module ToSource
  class Visitor
    def initialize
      @output = []
      @indentation = 0
    end

    def emit(code)
      @output.push code
    end

    def output
      @output.join
    end

    def current_indentation
      '  ' * @indentation
    end

    def local_variable_assignment(node, parent)
      emit "%s = " % node.name
      node.value.lazy_visit self, node
    end

    def local_variable_access(node, parent)
      emit node.name
    end

    def fixnum_literal(node, parent)
      emit node.value.to_s
    end

    def float_literal(node, parent)
      emit node.value.to_s
    end

    def string_literal(node, parent)
      emit ?" << node.string.to_s << ?"
    end

    def symbol_literal(node, parent)
      emit ?: << node.value.to_s
    end

    def true_literal(node, parent)
      emit 'true'
    end

    def false_literal(node, parent)
      emit 'false'
    end

    def nil_literal(node, parent)
      emit 'nil'
    end

    def array_literal(node, parent)
      body = node.body

      emit '['
      body.each_with_index do |node, index|
        node.lazy_visit self, node
        emit ', ' unless body.length == index + 1 # last element
      end
      emit ']'
    end

    def hash_literal(node, parent)
      body = node.array.each_slice(2)

      emit '{'
      body.each_with_index do |slice, index|
        key, value = slice

        key.lazy_visit self, node
        emit " => "
        value.lazy_visit self, node

        emit ', ' unless body.to_a.length == index + 1 # last element
      end
      emit '}'
    end

    def range(node, parent)
      node.start.lazy_visit self, node
      emit '..'
      node.finish.lazy_visit self, node
    end

    def regex_literal(node, parent)
      emit ?/
      emit node.source
      emit ?/
    end

    def send(node, parent)
      unless node.receiver.is_a?(Rubinius::AST::Self)
        node.receiver.lazy_visit self, node
        emit ?.
      end
      emit node.name

      if node.block
        emit ' '
        node.block.lazy_visit self, node if node.block
      end
    end

    def send_with_arguments(node, parent)
      unless node.receiver.is_a?(Rubinius::AST::Self)
        node.receiver.lazy_visit self, node
        emit ?.
      end

      emit node.name
      emit ?(
      node.arguments.lazy_visit self, node
      emit ?)
      if node.block
        emit ' '
        node.block.lazy_visit self, node if node.block
      end
    end

    def actual_arguments(node, parent)
      body = node.array
      body.each_with_index do |argument, index|
        argument.lazy_visit self, parent
        emit ', ' unless body.length == index + 1 # last element
      end
    end

    def iter_arguments(node, parent)
      body = if node.prelude == :single
        Array(node.arguments.name)
      else
        node.arguments.left.body.map(&:name)
      end

      emit ?|
      body.each_with_index do |argument, index|
        emit argument.to_s
        emit ', ' unless body.length == index + 1 # last element
      end
      emit ?|
    end

    def iter(node, parent)
      emit 'do'

      if node.arguments && node.arguments.arity != -1
        emit ' '
        node.arguments.lazy_visit self, parent
      end

      emit "\n"
      @indentation += 1

      if node.body.is_a?(Rubinius::AST::Block)
        node.body.lazy_visit self, parent, true
      else
        emit current_indentation
        node.body.lazy_visit self, parent
        emit "\n"
      end

      emit 'end'
    end

    def block(node, parent, indent=false)
      node.array.each do |expression|
        emit current_indentation if indent
        expression.lazy_visit self, parent
        emit "\n"
      end
    end
  end
end
