# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPushCommand
    CONSTANT_SEGMENT_NAME = 'constant'

    def call(segment, arg)
      if segment == CONSTANT_SEGMENT_NAME
        return push_constant_instructions(arg)
      end

      base_address_label = MemorySegments.segment_to_base_address_label(segment)
      push_instructions(base_address_label, arg)
    end

    private

    def push_instructions(base_address_label, step_from_base)
      <<-HACK
@#{base_address_label}
A=M+#{step_from_base}
D=M

@SP
A=M
M=D

@SP
M=M+1
      HACK
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
