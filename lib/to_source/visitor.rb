module ToSource
  class Visitor
    def initialize
      @output = []
    end

    def emit(code)
      @output.push code
    end

    def output
      @output.join
    end

    def local_variable_assignment(node, parent)
      emit "%s = " % node.name
      node.value.visit self, node
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

    def array_literal(node, parent)
      body = node.body

      emit '['
      node.body.each_with_index do |node, index|
        node.visit self, node
        emit ', ' unless body.length == index + 1 # last element
      end
      emit ']'
    end
  end
end
