# frozen_string_literal: true

require_relative 'emit_base'

class CodeSpitter
  class EmitMemoryAccessCommand < CodeSpitter::EmitBase
    def call(command, segment, value)
      result = command_comment(command, segment, value)
      result << "\n\n"
      result << command_instructions(command, segment, value)
      result
    end

    private

    def command_instructions(command, segment, value)
      case command
      when 'push'
        push_instructions(segment, value)
      when 'pop'
        pop_instructions(segment, value)
      end
    end

    def push_instructions(segment, value)
      case segment
      when 'constant'
        push_constant_instructions(value)
      end
    end

    def push_constant_instructions(value)
      <<-HACK
@#{value}
D=A

@SP
A=M
M=D

@SP
M=M+1
      HACK
    end
  end
end
