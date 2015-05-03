
def Rex_Dots? *args
  Rex_Dots.match? *args
end # === def Rex_Dots?

class Rex_Dots

  REX                 = /(\ {1,})|\(([^\(\)]+)\)|(.)/
  REX_CACHE           = {}
  ZERO_OR_MORE_SPACES = /\ */
  ONE_OR_MORE_SPACES  = /\ +/

  class << self

    def match? *args
      str = args.pop
      exp(*args).match str
    end

    def exp str, *args
      REX_CACHE[[str,args].to_s] ||= exp!(str, *args)
    end

    def exp! str, *custom
      i = -1
      base = str.scan(REX).map { |arr|
        case
        when arr[0]
          ONE_OR_MORE_SPACES

        when arr[1]
          key = arr[1].strip

          case key
          when '...'
            /\ *(.+?)\ */

          when '_'
            i += 1
            fail ArgumentError, "NO value set for #{i.inspect} -> #{str.inspect}" unless custom[i]
            '(' + custom[i].to_s + ')'

          when 'word'
            /\ *([^\ \)]+)\ */

          when 'white*'
            /([\ ]*)/

          when 'white+'
            /([\ ]+)/

          when 'num'
            /\ *([0-9\.\_\-]+)\ */

          when /\A![^\!]+/
            /\ *([^#{Regexp.escape key.sub('!', '')}]+)\ */

          else
            fail ArgumentError, "Unknown value for Regexp: #{arr[1].inspect} in #{str.inspect}"
          end # === case key

        when arr[2]
          Regexp.escape arr[2]

        else
          fail ArgumentError, "#{str.inspect} -> #{REG_EXP.inspect}"
        end # === case
      }

      if base.first == ONE_OR_MORE_SPACES
        base.shift
        base.unshift ZERO_OR_MORE_SPACES
      end

      if base.last == ONE_OR_MORE_SPACES
        base.pop
        base.push ZERO_OR_MORE_SPACES
      end

      /\A#{base.join}\Z/
    end # === def initialize

  end # === class self ===

end # === class Rex_Dots ===
