# frozen_string_literal: true

# The purpose of this class is to parse a string which contains VM command
class Parser
  COMMENT_PREFIX = '//'
  INSTRUCTION_REGEX = %r{(?<command>[a-z-]+)\s*(?<arg1>\w*)\s*(?<arg2>\w*)}

  def initialize(reader)
    @reader = reader
  end

  def each
    @reader.each do |line|
      parsed = parse_line(line)
      next unless parsed

      yield parsed
    end
  end

  def parse_line(line)
    return if line.start_with?(COMMENT_PREFIX)

    strip_inline_comments!(line)

    result = line.match(INSTRUCTION_REGEX)
    return unless result

    arg1 = result[:arg1]
    arg2 = result[:arg2]

    {
      command: result[:command],
      arg1: (arg1.empty? ? nil : arg1),
      arg2: (arg2.empty? ? nil : arg2)
    }
  end

  private

  def strip_inline_comments!(line)
    line.sub!(/(#{COMMENT_PREFIX}.*)/, '')
    line.strip!
  end
end
