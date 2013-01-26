# v0.2.17 2013-01-25

* [fixed] Fix op assign 1 operators with implicit index array[] ||= etc
* [fixed] Fix op assign 1 operators with explicit index array[foo] ||= etc
* [fixed] Add support regexp in if statements with implicit haystack (Rubinius::AST::Match)
* [fixed] Add support for Rubionius::AST::Flip{2,3} (flip flops)
* [fixed] Add support for Rubionius::AST::VAlias
* [fixed] Fix multiple edge cases with array literals and splats
* [fixed] Add support for mixed splat arguments 
* [fixed] Add support for __ENCODING__
* [fixed] Fix emit of splat arguments to binary method operators
* [fixed] Fix multiple assigments when assigning to element with splat index
* [fixed] Add support for retry
* [fixed] Add support for redo
* [fixed] Add support rubinius specific type constant
* [fixed] Add support for dynamic once literal
* [fixed] Emit regexp options for single and dynamic literals
* [fixed] Add support for undef keyword
* [fixed] Add support toplevel module name
* [fixed] Fix regexp emitter for edge cases
* [fixed] Fix element reference with splat arguments
* [fixed] Add support for construct
* [fixed] Add support splat assigmnent in multiple assignment
* [fixed] Add support for /s/ =~ foo (Rubinius::AST::Match2)
* [fixed] Add support for $` (Rubinius::AST::BackRef)
* [fixed] Support multiple assignments also for attribute and element assignments

[Compare v0.2.16..v0.2.17](https://github.com/mbj/to_source/compare/v0.2.16...v0.2.17)

# v0.2.16 2013-01-25

* [fixed] Handle Rubinius::AST::Case

[Compare v0.2.15..v0.2.16](https://github.com/mbj/to_source/compare/v0.2.15...v0.2.16)

# v0.2.15 2013-01-24

* [fixed] Emit dynamic regexp literals with split groups correctly

[Compare v0.2.14..v0.2.15](https://github.com/mbj/to_source/compare/v0.2.14...v0.2.15)

# v0.2.14 2013-01-09

* [fixed] Emit send with arguments and body correctly

[Compare v0.2.13..v0.2.14](https://github.com/mbj/to_source/compare/v0.2.13...v0.2.14)

# v0.2.13 2013-01-09

* [fixed] Emit send with arguments and body correctly

[Compare v0.2.12..v0.2.13](https://github.com/mbj/to_source/compare/v0.2.12...v0.2.13)

# v0.2.12 2013-01-09

* [fixed] Emit edge cases with dynamic literals correctly

[Compare v0.2.11..v0.2.12](https://github.com/mbj/to_source/compare/v0.2.11...v0.2.12)

# v0.2.11 2013-01-09

* [fixed] Allow all nodes to be entrypoints

[Compare v0.2.10..v0.2.11](https://github.com/mbj/to_source/compare/v0.2.10...v0.2.11)

# v0.2.10 2013-01-07

* [Changed] Rewrote internals compleatly, no outer API change
* [fixed] Emit indentation of complex nested structures with rescue statements correctly

[Compare v0.2.9..v0.2.10](https://github.com/mbj/to_source/compare/v0.2.9...v0.2.10)

# v0.2.9 2013-01-04

* [fixed] Handle regexp literals containing slashes in non shash delimiters %r(/) correctly

[Compare v0.2.8..v0.2.9](https://github.com/mbj/to_source/compare/v0.2.8...v0.2.9)

# v0.2.8 2013-01-03

* [Changed] Emit many times more ugly code, but correctnes > beautifulnes
* [fixed] Emit break with parantheses
* [fixed] Emit op assign and as "&&="
* [fixed] Emit op assign or as "||="

[Compare v0.2.7..v0.2.8](https://github.com/mbj/to_source/compare/v0.2.7...v0.2.8)

# v0.2.7 2013-01-02

* [fixed] Emit super with blocks correctly

[Compare v0.2.6..v0.2.7](https://github.com/mbj/to_source/compare/v0.2.6...v0.2.7)

# v0.2.6 2013-01-01

* [fixed] Emit super vs super() correctly

[Compare v0.2.5..v0.2.6](https://github.com/mbj/to_source/compare/v0.2.5...v0.2.6)

# v0.2.5 2012-12-14

* [fixed] Emit unary operators correctly
* [fixed] Define with optional splat and block argument
* [fixed] Emit arguments to break keyword
* [change] Uglify output of binary operators with unneded paranteses. Correct output > nice output.
* [fixed] Emit nested binary operators correctly.
* [fixed] Emit element reference on self correctly. self[foo].

[Compare v0.2.4..v0.2.5](https://github.com/mbj/to_source/compare/v0.2.4...v0.2.5)

# v0.2.4 2012-12-07

* [feature] Allow to emit pattern variables as root node
* [fixed] Emit send with splat and block argument correctly

[Compare v0.2.3..v0.2.4](https://github.com/mbj/to_source/compare/v0.2.3...v0.2.4)

# v0.2.3 2012-12-07

* [fixed] Nuke dangling require  (sorry for not running specs after gemspec change)

[Compare v0.2.2..v0.2.3](https://github.com/mbj/to_source/compare/v0.2.2...v0.2.3)

# v0.2.2 2012-12-07

* [fixed] Emit of pattern arguments with no formal arguments present
* [fixed] Missed to require set

[Compare v0.2.1..v0.2.2](https://github.com/mbj/to_source/compare/v0.2.1...v0.2.2)

# v0.2.1 2012-12-07

* [fixed] Emit of def on splat with block
* [fixed] Emit of pattern args 

[Compare v0.2.0..v0.2.1](https://github.com/mbj/to_source/compare/v0.2.0...v0.2.1)

# v0.2.0 2012-12-07

* [BRAKING CHANGE] Remove core extension Rubinius::AST::Node#to_source (mbj)
* [feature] Add support for MRI via melbourne gem (mbj)
* [fixed] 100% Yard covered documentation (mbj)
* [fixed] Emit most binary operators without parantheses (mbj)
* [feature] Port tests to rspec2 and greatly improve coverage and layout of these.
* [feature] Introduce metric tools via devtools
* [fixed] Lots of transitvity edge cases

[Compare v0.1.3..v0.2.0](https://github.com/mbj/to_source/ompare/v0.1.3...v0.2.0)
