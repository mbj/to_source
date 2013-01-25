module ToSource
  class Emitter
    class Literal
      class Regexp
        class Options < Emitter

          # No constants for this under ::Regexp in MRI
          # So stole this from nice player rubinius kernel/common/regexp.rb
          KCODE_NONE = (1 << 9)
          KCODE_EUC  = (2 << 9)
          KCODE_SJIS = (3 << 9)
          KCODE_UTF8 = (4 << 9)
          KCODE_MASK = KCODE_NONE | KCODE_EUC | KCODE_SJIS | KCODE_UTF8

          GENERIC = IceNine.deep_freeze(
            ::Regexp::EXTENDED      => 'x',
            # FIXME: Documented but no option flag?
            #::Regexp::FIXEDENCODING => '',
            ::Regexp::IGNORECASE    => 'i',
            ::Regexp::MULTILINE     => 'm'
          )

          KCODES = IceNine.deep_freeze(
            KCODE_NONE  => 'n',
            KCODE_EUC   => 'e',
            KCODE_SJIS  => 's',
            KCODE_UTF8  => 'u'
          )

        private

          # Perform dispatch
          #
          # @return [self]
          #
          # @api private
          #
          def dispatch
            emit_generic_flags
            emit_kcode_flag
          end

          # Emit kcode flag
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_kcode_flag
            emit(KCODES.fetch(node & KCODE_MASK, ''))
          end

          # Emit generic flags
          #
          # @return [undefined]
          #
          # @api private
          #
          def emit_generic_flags
            GENERIC.each do |option, flag|
              unless (node & option).zero?
                emit(flag)
              end
            end
          end

        end
      end
    end
  end
end
