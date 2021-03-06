require 'spec_helper'

describe ToSource,'.to_source' do
  def compress(code)
    lines = code.split("\n")
    match = /\A( *)/.match(lines.first)
    whitespaces = match[1].to_s.length
    stripped = lines.map do |line|
      line[whitespaces..-1]
    end
    joined = stripped.join("\n")
  end

  def assert_round_trip(code)
    node = code.to_ast
    generated = ToSource.to_source(node)
    generated.should eql(code)
    # This is nonsense but I had a case where it helps?
    second_node = generated.to_ast
    second = ToSource.to_source(second_node)
    second.should eql(code)
  end

  def assert_entrypoints(node)
    node.instance_variables.each do |ivar|
      value = node.instance_variable_get(ivar)
      next unless value.kind_of?(Rubinius::AST::Node)
      ToSource.to_source(value)
      assert_entrypoints(value)
    end
  end

  shared_examples_for 'a source generation method' do
    it 'should create original source' do
      assert_round_trip(compress(expected_source))
    end

    it 'should be able to use all wrapped nodes as entrypoints' do
      assert_entrypoints(expected_source.to_ast)
    end
  end

  def self.assert_source(source)
    let(:node)            { source.to_ast }
    let(:source)          { source        }
    let(:expected_source) { source        }

    it_should_behave_like 'a source generation method'
  end

  def self.assert_converts(target, original)
    let(:node)            { original.to_ast }
    let(:source)          { original        }
    let(:expected_source) { target          }
    it_should_behave_like 'a source generation method'
  end

  context 'class' do
    context 'simple' do
      assert_source <<-RUBY
        class TestClass

        end
      RUBY
    end

    context 'singleton class inheritance' do
      assert_source <<-RUBY
        class << some_object
          the_body
        end
      RUBY
    end

    context 'scoped' do
      assert_source <<-RUBY
        class SomeNameSpace::TestClass

        end
      RUBY
    end

    context 'deeply scoped' do
      assert_source <<-RUBY
        class Some::Name::Space::TestClass

        end
      RUBY
    end

    context 'with subclass' do
      assert_source <<-RUBY
        class TestClass < Object

        end
      RUBY
    end

    context 'with scoped superclass' do
      assert_source <<-RUBY
        class TestClass < SomeNameSpace::Object

        end
      RUBY
    end

    context 'with body' do
      assert_source <<-RUBY
        class TestClass
          def foo
            :bar
          end
        end
      RUBY
    end
    
    context 'toplevel' do
      assert_source <<-RUBY
        class ::TestClass

        end
      RUBY
    end
  end

  context 'module nodes' do
    context 'simple' do
      assert_source <<-RUBY 
        module TestModule

        end
      RUBY
    end

    context 'scoped' do
      assert_source <<-RUBY
        module SomeNameSpace::TestModule

        end
      RUBY
    end

    context 'deeply scoped' do
      assert_source <<-RUBY
        module Some::Name::Space::TestModule

        end
      RUBY
    end

    context 'with body' do
      assert_source <<-RUBY
        module TestModule
          def foo
            :bar
          end
        end
      RUBY
    end
  end

  context 'single assignment' do
    context 'to local variable' do
      assert_source 'foo = 1'
    end

    context 'to instance variable' do
      assert_source '@foo = 1'
    end

    context 'to global variable' do
      assert_source '$foo = 1'
    end

    context 'to class variable' do
      assert_source '@@foo = 1'
    end


    context 'to constant' do
      assert_source 'SOME_CONSTANT = 1'
    end
  end


  %w(|= ||= &= &&= += -= *= /= **= %=).each do |op|
    context "conditional attribute #{op} assignment" do
      assert_source "self.foo #{op} bar"
    end

    context "conditional element #{op} assignment" do
      assert_source "foo[key] #{op} bar"
    end
  end


  context 'element assignment' do
    context 'simpe' do
      assert_source 'array[index] = value'
    end

    context 'splat index' do
      assert_source 'array[*index] = value'
    end

    context 'with assignment operator' do
      %w(+ - * / % & | || &&).each do |operator|
        context "with #{operator}" do
          context 'explicit index' do
            assert_source "array[index] #{operator}= 2"
          end

          context 'implicit index' do
            assert_source "array[] #{operator}= 2"
          end
        end
      end
    end
  end

  context 'multiple assignment' do
    context 'to local variable' do
      assert_source 'a, b = 1, 2'
    end

    context 'to local and splat var' do
      assert_source 'a, *foo = 1, 2'
    end

    context 'with empty splat' do
      assert_source 'a, * = 1, 2'
    end

    context 'to splat var' do
      assert_source '*foo = 1, 2'
    end

    context 'to instance variable' do
      assert_source '@a, @b = 1, 2'
    end

    context 'to attribute reference' do
      assert_source 'a.foo, a.bar = 1, 2'
    end

    context 'to element' do
      assert_source 'a[0], a[1] = 1, 2'
    end

    context 'to spat element' do
      assert_source 'a[*foo], a[1] = 1, 2'
    end

    context 'to class variable' do
      assert_source '@@a, @@b = 1, 2'
    end

    context 'to global variable' do
      assert_source '$a, $b = 1, 2'
    end

    context 'unbalanced' do
      assert_source 'a, b = foo'
    end
  end

  context 'defined' do
    context 'with instance varialbe' do
      assert_source <<-RUBY
        defined?(@foo)
      RUBY
    end

    context 'with constant' do
      assert_source <<-RUBY
        defined?(Foo)
      RUBY
    end
  end

  context 'access' do
    context 'on local variable' do
      assert_source <<-RUBY
        foo = 1
        foo
      RUBY
    end

    context 'on class variable' do
      assert_source '@@foo'
    end

    context 'on nth ref global variable' do
      assert_source '$1'
    end

    context 'on back ref global variable' do
      assert_source '$`'
    end

    context 'on global variable' do
      assert_source '$foo'
    end

    context 'on instance variable' do
      assert_source '@foo'
    end

    context 'toplevel constant' do
      assert_source '::Rubinius'
    end

    context 'constant' do
      assert_source 'Rubinius'
    end

    context 'scoped constant' do
      assert_source 'Rubinius::Debugger'
    end
  end

  context 'literal' do
    context 'number' do
      assert_source '12379813738877118345'
    end

    context 'fixnum' do
      assert_source '1' 
    end

    context 'float' do
      assert_source '1.0'
    end

    context 'negated numeric' do
      assert_source '-1'
    end

    context 'string' do
      assert_source '"foo"'
    end

    context 'execute string' do
      assert_source '`foo`'
    end

    context 'symbol' do
      assert_source ':foo'
    end

    context 'true' do
      assert_source 'true'
    end

    context 'false' do
      assert_source 'false'
    end

    context 'nil' do
      assert_source 'nil'
    end

    context 'empty array' do
      assert_source '[]'
    end

    context 'array' do
      context 'simple' do
        assert_source '[1, 2, 3]'
      end

      context 'with splat in the end' do
        assert_source '[1, *foo]'
      end

      context 'with splat in the beginning' do
        assert_source '[*foo, 1]'
      end

      context 'with splat in the beginning and end' do
        assert_source '[*foo, *baz]'
      end
    end

    context 'empty hash' do
      assert_source '{}'
    end

    context 'hash' do
      assert_source '{:answer => 42, :bar => :baz}'
    end

    context 'range' do
      context 'inclusive' do
        assert_source '(20..34)'
      end

      context 'expression in bounds' do
        assert_source '(foo..bar)'
      end

      context 'exclusive range' do
        assert_source '(20...34)'
      end
    end

    context 'regexp' do
      context 'simple' do
        assert_source '/.*/'
      end

      context 'with character classes' do
        assert_source %q(/[^-+',.\/:@[:alnum:]\[\]\x80-\xff]+/)
      end

      context 'with options' do

        context 'case insensitive' do
          assert_source '//i'
        end

        context 'ignore comments and whitespace' do
          assert_source '//x'
        end

        context 'assci encoding' do
          assert_source '//n'
        end

        context 'windows-31j encoding' do
          assert_source '//s'
        end

        context 'euc-jp encoding' do
          assert_source '//e'
        end

        context 'utf-8 encoding' do
          assert_source '//u'
        end

        context 'multiline' do
          assert_source '//m'
        end

      end

      context 'with escapes' do
        assert_source '/\//'
      end

      context 'with non slash literal containing slashes' do
        assert_converts '/\//', '%r(/)'
      end
    end

    context 'dynamic string' do
      context 'simple' do
        assert_source '"foo#{bar}baz"'
      end

      context 'with escapes' do
        assert_source '"fo\no#{bar}b\naz"'
      end

      context 'with dynamic segment in the front' do
        assert_source '"#{bar}foo"'
      end

      context 'with dynamic segment in the end' do
        assert_source '"foo#{bar}"'
      end
    end

    context 'dynamic symbol' do
      context 'simple' do
        assert_source ':"foo#{bar}baz"'
      end

      context 'with escapes' do
        assert_source ':"fo\no#{bar}b\naz"'
      end

      context 'with dynamic segment in the front' do
        assert_source ':"#{bar}foo"'
      end

      context 'with dynamic segment in the end' do
        assert_source ':"foo#{bar}"'
      end
    end

    context 'dynamic execute' do
      context 'simple' do
        assert_source '`foo#{bar}baz`'
      end

      context 'with escapes' do
        assert_source '`fo\no#{bar}b\naz`'
      end

      context 'with dynamic segment in the front' do
        assert_source '`#{bar}foo`'
      end

      context 'with dynamic segment in the end' do
        assert_source '`foo#{bar}`'
      end
    end

    context 'dynamic regexp' do
      context 'simple' do
        assert_source '/foo#{bar}baz/'
      end

      context 'with flags' do
        assert_source '/foo#{bar}/i'
        assert_source '/foo#{bar}/m'
        assert_source '/foo#{bar}/im'
        assert_source '/foo#{bar}/imx'
        assert_source '/foo#{bar}/x'
      end

      context 'split groups' do
        assert_source '/(#{foo})*/'
      end

      context 'with escapes' do
        assert_source '/fo\no#{bar}b\naz/'
      end

      context 'with dynamic segment in the front' do
        assert_source '/#{bar}foo/'
      end

      context 'with dynamic segment in the end' do
        assert_source '/foo#{bar}/'
      end

      context 'with o flag' do
        assert_source '/foo#{bar}/o'
      end

      context 'with o and other flags' do
        assert_source '/foo#{bar}/oim'
      end
    end
  end

  context 'END' do
    original = <<-RUBY
      END { 
        foo 
      }
    RUBY

    target = <<-RUBY
      at_exit do
        foo
      end
    RUBY

    assert_converts target, original
  end

  context 'send' do
    context 'as element reference' do
      assert_source 'foo[index]'
    end

    context 'as element reference with splat' do
      assert_source 'self[*foo]'
    end

    context 'as element reference on self' do
      assert_source 'self[foo]'
    end

    context 'without arguments' do
      assert_source 'foo.bar'
    end

    context 'with arguments' do
      assert_source 'foo.bar(:baz, :yeah)'
    end

    context 'to self' do

      context 'explicitly' do
        assert_source 'self.foo'
      end

      context 'explicitly with message name equals a keyword' do
        assert_source 'self.and'
      end

      context 'implicitly' do
        assert_source 'foo'
      end

      context 'with arguments' do
        context 'implicitly' do
          assert_source 'bar(:baz, :yeah)'
        end

        context 'explicitly' do
          assert_source 'self.bar(:baz, :yeah)'
        end
      end
    end

    context 'with block' do
      assert_source <<-RUBY
        foo.bar do
          3
          4
        end
      RUBY
    end

    context 'with block that takes pattern and formal arguments' do
      assert_source <<-RUBY
        foo.bar do |(a, b), c|
          d
        end
      RUBY
    end


    context 'with block that takes pattern and no formal arguments' do
      assert_source <<-RUBY
        foo.bar do |(a, b)|
          d
        end
      RUBY
    end

    context 'with block that takes arguments' do
      assert_source <<-RUBY 
        foo.bar do |a|
          3
          4
        end
      RUBY
    end

    context 'with arguments and block' do
      assert_source <<-RUBY 
        foo.bar(baz) do
          4
        end
      RUBY
    end

    context 'with splat argument' do
      assert_source 'foo.bar(*args)'
    end

    context 'with formal splat and formal argument' do
      assert_source 'foo.bar(*arga, foo, *argb)'
    end

    context 'with splat and formal argument' do
      assert_source 'foo.bar(*args, foo)'
    end

    context 'with formal and splat argument' do
      assert_source 'foo.bar(foo, *args)'
    end

    context 'with formal splat and block argument' do
      assert_source 'foo.bar(foo, *args, &block)'
    end

    context 'with formal splat and block' do
      assert_source <<-RUBY
        foo(bar, *args)
      RUBY
    end

    context 'with splat and block argument' do
      assert_source <<-RUBY
        foo(*args, &block)
      RUBY
    end

    context 'with passing block argument' do
      assert_source 'foo.bar(&baz)'
    end

    context 'with formal and  block argument' do
      assert_source 'foo.bar(:baz, &baz)'
    end

    context 'attribute assignment' do
      context 'on foreign object' do
        assert_source 'foo.bar = :baz'
      end

      context 'on self' do
        assert_source 'self.foo = :bar'
      end
    end
  end

  context 'lambda' do
    assert_source <<-RUBY
      lambda do |a, b|
        a
      end
    RUBY
  end

  context 'super' do
    context 'without arguments' do
      assert_source 'super'
    end

    context 'without arguments and block' do
      assert_source <<-RUBY
        super do
          foo
        end
      RUBY
    end

    context 'with explicit zero arguments' do
      assert_source 'super()'
    end

    context 'with explicit zero arguments and block' do
      assert_source <<-RUBY
        super() do
          foo
        end
      RUBY
    end

    context 'with argument' do
      assert_source 'super(a)'
    end

    context 'with argument and block' do
      assert_source <<-RUBY
        super(a) do
          foo
        end
      RUBY
    end

    context 'with arguments' do
      assert_source 'super(a, b)'
    end

    context 'with arguments and block' do
      assert_source <<-RUBY
        super(a, b) do
          foo
        end
      RUBY
    end

    context 'with block argument' do
      assert_source 'super(&block)'
    end

    context 'with formal and block argument' do
      assert_source 'super(a, &block)'
    end
  end

  context 'break' do
    assert_source 'break'
  end

  context 'break with arguments' do
    assert_source 'break(a)'
  end

  context 'retry' do
    assert_source 'retry'
  end

  context 'redo' do
    assert_source 'redo'
  end

  context 'next' do
    assert_source 'next'
  end

  context 'match2 operator' do
    assert_source <<-RUBY
      /bar/ =~ foo
    RUBY
  end

  context 'match3 operator' do
    assert_source <<-RUBY
      foo =~ /bar/
    RUBY
  end

  context 'flip flops' do
    context 'flip2' do
      assert_source <<-RUBY
        if (((i) == (4)))..(((i) == (4)))
          foo
        end
      RUBY
    end

    context 'flip3' do
      assert_source <<-RUBY
        if (((i) == (4)))...(((i) == (4)))
          foo
        end
      RUBY
    end
  end

  context 'valias' do
    assert_source <<-RUBY
      alias $foo $bar
    RUBY
  end

  context 'alias' do
    assert_source <<-RUBY
      alias foo bar
    RUBY
  end

  context 'yield' do
    context 'without arguments' do
      assert_source 'yield'
    end

    context 'with argument' do
      assert_source 'yield(a)'
    end

    context 'with arguments' do
      assert_source 'yield(a, b)'
    end
  end

  context 'binary operators methods' do
    %w(+ - * / & | << >> == === != <= < <=> > >= =~ !~ ^ **).each do |operator|
      context "on literals #{operator}" do
        assert_source "((1) #{operator} (2))"
      end

      context "#{operator} with splat args" do
        assert_source "((left).#{operator}(*foo))"
      end

      context "on self #{operator}" do
        assert_source "((self) #{operator} (b))"
      end

      context "on send #{operator}" do
        assert_source "((a) #{operator} (b))"
      end
    end
  end

   context 'binary operator' do
     context 'and keywords' do
       assert_source '((a) || (break(foo)))'
     end

     context 'sending methods to result' do
       assert_source '((a) || (b)).foo'
     end

     context 'nested' do
       assert_source '((a) || (((b) || (c))))'
     end
   end

  { :or => :'||', :and => :'&&' }.each do |word, symbol|
    context "word form form equivalency of #{word} and #{symbol}" do
      assert_converts "((a) #{symbol} (break(foo)))", "a #{word} break foo"
    end
  end

  context 'expansion of shortcuts' do
    context 'on += operator' do
      assert_converts 'a = ((a) + (2))', 'a += 2'
    end

    context 'on -= operator' do
      assert_converts 'a = ((a) - (2))', 'a -= 2'
    end

    context 'on **= operator' do
      assert_converts 'a = ((a) ** (2))', 'a **= 2'
    end

    context 'on *= operator' do
      assert_converts 'a = ((a) * (2))', 'a *= 2'
    end

    context 'on /= operator' do
      assert_converts 'a = ((a) / (2))', 'a /= 2'
    end
  end

  context 'shortcuts' do
    context 'on &&= operator' do
      assert_source '(a &&= (b))'
    end

    context 'on ||= operator' do
      assert_source '(a ||= (2))'
    end

    context 'calling methods on shortcuts' do
      assert_source '(a ||= (2)).bar'
    end
  end

  context 'unary operators' do
    context 'negation' do
      assert_source '!1'
    end

    context 'double negation' do
      assert_source '!!1'
    end

    context 'unary match' do
      assert_source '~a'
    end

    context 'unary minus' do
      assert_source '-a'
    end

    context 'unary plus' do
      assert_source '+a'
    end
  end

  context 'if statement' do
    context 'when matching regexp' do
      assert_source <<-RUBY
        if /foo/
          bar
        end
      RUBY
    end
    context 'without else branch' do
      context 'single statement in branch' do
        assert_source <<-RUBY
          if 3
            9
          end
        RUBY
      end

      context 'multiple statements in branch' do
        assert_source <<-RUBY
          if 3
            9
            10
          end
        RUBY
      end
    end

    context 'with else branch' do
      context 'single expression in branch' do
        assert_source <<-RUBY
          if 4
            5
          else
            6
          end
        RUBY
      end

      context 'multiple expressions in branch' do
        assert_source <<-RUBY
          if 4
            5
          else
            6
            7
          end
        RUBY
      end
    end

    context 'unless' do
      context 'single statement in branch' do
        assert_source <<-RUBY
          unless 3
            9
          end
        RUBY
      end

      context 'single statement in branch' do
        assert_source <<-RUBY
          unless 3
            9
            10
          end
        RUBY
      end
    end
  end

  context 'case statement' do
    context 'without else branch' do
      assert_source <<-RUBY
        case 
        when bar
          baz
        when baz
          bar
        end
      RUBY
    end
  end

  context 'receiver case statement' do
    context 'without else branch' do
      assert_source <<-RUBY
        case foo
        when bar
          baz
        when baz
          bar
        end
      RUBY
    end

    context 'with multivalued conditions' do
      assert_source <<-RUBY
        case foo
        when bar, baz
          :other
        end
      RUBY
    end

    context 'with splat operator' do
      assert_source <<-RUBY
        case foo
        when *bar
          :value
        end
      RUBY
    end

    context 'with else branch' do
      assert_source <<-RUBY
        case foo
        when bar
          baz
        else
          :foo
        end
      RUBY
    end
  end

  context 'for' do
    context 'single assignment' do
      assert_source <<-RUBY
        for a in bar do
          baz
        end
      RUBY
    end

    context 'splat assignment' do
      assert_source <<-RUBY
        for a, *b in bar do
          baz
        end
      RUBY
    end

    context 'multiple assignment' do
      assert_source <<-RUBY
        for a, b in bar do
          baz
        end
      RUBY
    end
  end

  context 'loop' do
    assert_source <<-RUBY
      loop do
        foo
      end
    RUBY
  end

  context 'while' do
    context 'single statement in body' do
      assert_source <<-RUBY
        while false
          3
        end
      RUBY
    end

    context 'multiple expressions in body' do
      assert_source <<-RUBY
        while false
          3
          5
        end
      RUBY
    end
  end

  context 'until' do
    context 'with single expression in body' do
      assert_source <<-RUBY
        until false
          3
        end
      RUBY
    end

    context 'with multiple expressions in body' do
      assert_source <<-RUBY 
        while false
          3
          5
        end
      RUBY
    end
  end

  # Note:
  #
  # Do not remove method_call from
  #
  # begin
  #   stuff
  # end.method_call 
  #
  # As 19mode would optimize begin end blocks away
  #
  context 'begin' do
    context 'simple' do
      assert_source <<-RUBY
        begin
          foo
          bar
        end.some_method
      RUBY
    end

    context 'with rescue condition' do
      assert_source <<-RUBY
        x = begin
          foo
        rescue
          bar
        end.some_method
      RUBY
    end

    context 'with with ensure' do
      assert_source <<-RUBY
        begin
          foo
        ensure
          bar
        end.some_method
      RUBY
    end
  end

  context 'rescue' do
    context 'as block' do
      assert_source <<-RUBY
        begin
          foo
          foo
        rescue
          bar
        end
      RUBY
    end
    context 'without rescue condition' do
      assert_source <<-RUBY
        begin
          bar
        rescue
          baz
        end
      RUBY
    end

    context 'within a block' do
      assert_source <<-RUBY
        foo do
          begin
            bar
          rescue
            baz
          end
        end
      RUBY
    end

    context 'with rescue condition' do
      context 'without assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError
            baz
          end
        RUBY
      end

      context 'with assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError => exception
            baz
          end
        RUBY
      end
    end

    context 'with multivalued rescue condition' do
      context 'without assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError, SomeOtherError
            baz
          end
        RUBY
      end

      context 'with assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError, SomeOther => exception
            baz
          end
        RUBY
      end
    end

    context 'with multiple rescue conditions' do
      assert_source <<-RUBY
        begin
          foo
        rescue SomeError
          bar
        rescue
          baz
        end
      RUBY
    end

    context 'with normal and splat condition' do
      context 'without assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError, *bar
            baz
          end
        RUBY
      end

      context 'with assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue SomeError, *bar => exception
            baz
          end
        RUBY
      end
    end

    context 'with splat condition' do
      context 'without assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue *bar
            baz
          end
        RUBY
      end

      context 'with assignment' do
        assert_source <<-RUBY
          begin
            bar
          rescue *bar => exception
            baz
          end
        RUBY
      end
    end
  end

  context '__ENCODING__' do
    assert_source '__ENCODING__'
  end

  context '__FILE__' do
    assert_source '__FILE__'
  end

  context 'ensure' do
    assert_source <<-RUBY
      begin
        bar
      ensure
        baz
      end
    RUBY
  end

  context 'return' do
    context 'with expression' do
      assert_source 'return(9)'
    end

    context 'without expression' do
      assert_source 'return'
    end
  end

  context 'undef' do
    assert_source 'undef :foo'
  end

  context 'define' do
    context 'on instance' do
      context 'without arguments' do
        assert_source <<-RUBY
          def foo
            bar
          end
        RUBY
      end

      context 'with single argument' do
        assert_source <<-RUBY
          def foo(bar)
            bar
          end
        RUBY
      end

      context 'with multiple arguments' do
        assert_source <<-RUBY
          def foo(bar, baz)
            bar
          end
        RUBY
      end

      context 'with optional argument' do
        assert_source <<-RUBY
          def foo(bar = true)
            bar
          end
        RUBY
      end

      context 'with required and optional arguments' do
        assert_source <<-RUBY
          def foo(bar, baz = true)
            bar
          end
        RUBY
      end

      context 'with unnamed splat argument' do
        assert_source <<-RUBY
          def foo(*)
            bar
          end
        RUBY
      end

      context 'with splat argument' do
        assert_source <<-RUBY
          def foo(*bar)
            bar
          end
        RUBY
      end

      context 'with required and splat arguments' do
        assert_source <<-RUBY
          def foo(bar, *baz)
            bar
          end
        RUBY
      end

      context 'with optional and splat argument' do
        assert_source <<-RUBY
          def foo(baz = true, *bor)
            bar
          end
        RUBY
      end

      context 'with optional and splat and block argument' do
        assert_source <<-RUBY
          def foo(baz = true, *bor, &block)
            bar
          end
        RUBY
      end

      context 'with required optional and splat argument' do
        assert_source <<-RUBY
          def foo(bar, baz = true, *bor)
            bar
          end
        RUBY
      end

      context 'with block argument' do
        assert_source <<-RUBY
          def foo(&block)
            bar
          end
        RUBY
      end

      context 'with required and block arguments' do
        assert_source <<-RUBY
          def foo(bar, &block)
            bar
          end
        RUBY
      end

      context 'with spat and block arguments' do
        assert_source <<-RUBY
          def initialize(attributes, options)
            @attributes = freeze_object(attributes)
            @options = freeze_object(options)
            @attribute_for = Hash[@attributes.map do |attribute|
              attribute.name
            end.zip(@attributes)]
            @keys = coerce_keys
          end
        RUBY
      end
    end

    context 'on singleton' do
      context 'on self' do
        assert_source <<-RUBY
          def self.foo
            bar
          end
        RUBY
      end

      context 'on constant' do
        assert_source <<-RUBY
          def Foo.bar
            bar
          end
        RUBY
      end
    end
  end
end
