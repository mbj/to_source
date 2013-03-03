# v0.2.19 2013-03-30

* [fix] Op assign 2 operators (self.foo ||= bar, etc) [nevir]

[Compare v0.2.19..v0.2.20](https://github.com/mbj/to_source/compare/v0.2.18...v0.2.20)

# v0.2.19 2013-03-1

* [change] Bump dependencies

[Compare v0.2.18..v0.2.19](https://github.com/mbj/to_source/compare/v0.2.18...v0.2.19)

# v0.2.18 2013-01-29

* [fix] Emit ranges in parantheses to resolve ambiguity

[Compare v0.2.17..v0.2.18](https://github.com/mbj/to_source/compare/v0.2.17...v0.2.18)

# v0.2.17 2013-01-26

* [fix] Fix op assign 1 operators with implicit index array[] ||= etc
* [fix] Fix op assign 1 operators with explicit index array[foo] ||= etc
* [fix] Add support regexp in if statements with implicit haystack (Rubinius::AST::Match)
* [fix] Add support for Rubionius::AST::Flip{2,3} (flip flops)
* [fix] Add support for Rubionius::AST::VAlias
* [fix] Fix multiple edge cases with array literals and splats
* [fix] Add support for mixed splat arguments 
* [fix] Add support for __ENCODING__
* [fix] Fix emit of splat arguments to binary method operators
* [fix] Fix multiple assigments when assigning to element with splat index
* [fix] Add support for retry
* [fix] Add support for redo
* [fix] Add support rubinius specific type constant
* [fix] Add support for dynamic once literal
* [fix] Emit regexp options for single and dynamic literals
* [fix] Add support for undef keyword
* [fix] Add support toplevel module name
* [fix] Fix regexp emitter for edge cases
* [fix] Fix element reference with splat arguments
* [fix] Add support for construct
* [fix] Add support splat assigmnent in multiple assignment
* [fix] Add support for /s/ =~ foo (Rubinius::AST::Match2)
* [fix] Add support for $` (Rubinius::AST::BackRef)
* [fix] Support multiple assignments also for attribute and element assignments

[Compare v0.2.16..v0.2.17](https://github.com/mbj/to_source/compare/v0.2.16...v0.2.17)

# v0.2.16 2013-01-25

* [fix] Handle Rubinius::AST::Case

[Compare v0.2.15..v0.2.16](https://github.com/mbj/to_source/compare/v0.2.15...v0.2.16)

# v0.2.15 2013-01-24

* [fix] Emit dynamic regexp literals with split groups correctly

[Compare v0.2.14..v0.2.15](https://github.com/mbj/to_source/compare/v0.2.14...v0.2.15)

# v0.2.14 2013-01-09

* [fix] Emit send with arguments and body correctly

[Compare v0.2.13..v0.2.14](https://github.com/mbj/to_source/compare/v0.2.13...v0.2.14)

# v0.2.13 2013-01-09

* [fix] Emit send with arguments and body correctly

[Compare v0.2.12..v0.2.13](https://github.com/mbj/to_source/compare/v0.2.12...v0.2.13)

# v0.2.12 2013-01-09

* [fix] Emit edge cases with dynamic literals correctly

[Compare v0.2.11..v0.2.12](https://github.com/mbj/to_source/compare/v0.2.11...v0.2.12)

# v0.2.11 2013-01-09

* [fix] Allow all nodes to be entrypoints

[Compare v0.2.10..v0.2.11](https://github.com/mbj/to_source/compare/v0.2.10...v0.2.11)

# v0.2.10 2013-01-07

* [Changed] Rewrote internals compleatly, no outer API change
* [fix] Emit indentation of complex nested structures with rescue statements correctly

[Compare v0.2.9..v0.2.10](https://github.com/mbj/to_source/compare/v0.2.9...v0.2.10)

# v0.2.9 2013-01-04

* [fix] Handle regexp literals containing slashes in non shash delimiters %r(/) correctly

[Compare v0.2.8..v0.2.9](https://github.com/mbj/to_source/compare/v0.2.8...v0.2.9)

# v0.2.8 2013-01-03

* [Changed] Emit many times more ugly code, but correctnes > beautifulnes
* [fix] Emit break with parantheses
* [fix] Emit op assign and as "&&="
* [fix] Emit op assign or as "||="

[Compare v0.2.7..v0.2.8](https://github.com/mbj/to_source/compare/v0.2.7...v0.2.8)

# v0.2.7 2013-01-02

* [fix] Emit super with blocks correctly

[Compare v0.2.6..v0.2.7](https://github.com/mbj/to_source/compare/v0.2.6...v0.2.7)

# v0.2.6 2013-01-01

* [fix] Emit super vs super() correctly

[Compare v0.2.5..v0.2.6](https://github.com/mbj/to_source/compare/v0.2.5...v0.2.6)

# v0.2.5 2012-12-14

* [fix] Emit unary operators correctly
* [fix] Define with optional splat and block argument
* [fix] Emit arguments to break keyword
* [change] Uglify output of binary operators with unneded paranteses. Correct output > nice output.
* [fix] Emit nested binary operators correctly.
* [fix] Emit element reference on self correctly. self[foo].

[Compare v0.2.4..v0.2.5](https://github.com/mbj/to_source/compare/v0.2.4...v0.2.5)

# v0.2.4 2012-12-07

* [feature] Allow to emit pattern variables as root node
* [fix] Emit send with splat and block argument correctly

[Compare v0.2.3..v0.2.4](https://github.com/mbj/to_source/compare/v0.2.3...v0.2.4)

# v0.2.3 2012-12-07

* [fix] Nuke dangling require  (sorry for not running specs after gemspec change)

[Compare v0.2.2..v0.2.3](https://github.com/mbj/to_source/compare/v0.2.2...v0.2.3)

# v0.2.2 2012-12-07

* [fix] Emit of pattern arguments with no formal arguments present
* [fix] Missed to require set

[Compare v0.2.1..v0.2.2](https://github.com/mbj/to_source/compare/v0.2.1...v0.2.2)

# v0.2.1 2012-12-07

* [fix] Emit of def on splat with block
* [fix] Emit of pattern args 

[Compare v0.2.0..v0.2.1](https://github.com/mbj/to_source/compare/v0.2.0...v0.2.1)

# v0.2.0 2012-12-07

* [BRAKING CHANGE] Remove core extension Rubinius::AST::Node#to_source (mbj)
* [feature] Add support for MRI via melbourne gem (mbj)
* [fix] 100% Yard covered documentation (mbj)
* [fix] Emit most binary operators without parantheses (mbj)
* [feature] Port tests to rspec2 and greatly improve coverage and layout of these.
* [feature] Introduce metric tools via devtools
* [fix] Lots of transitvity edge cases

[Compare v0.1.3..v0.2.0](https://github.com/mbj/to_source/ompare/v0.1.3...v0.2.0)
