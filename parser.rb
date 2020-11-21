# frozen_string_literal: true

# The purpose of this class is to parse a string which contains VM command
class Parser
  INSTRUCTION_REGEX = %r{(?<command>[a-z-]+)\s*(?<arg1>\w*)\s*(?<arg2>\w*)}

  def parse_line(line)
    result = line.match(INSTRUCTION_REGEX)
    arg1 = result[:arg1]
    arg2 = result[:arg2]

    {
      command: result[:command],
      arg1: (arg1.empty? ? nil : arg1),
      arg2: (arg2.empty? ? nil : arg2)
    }
  end
end
