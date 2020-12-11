# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPopCommand
    def call(segment, step_from_base)
      base_address_label = MemorySegments.segment_to_base_address_label(segment)
      pop_instructions(base_address_label, step_from_base)
    end

    private

    def pop_instructions(base_address_label, step_from_base)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@#{base_address_label}
A=M+#{step_from_base}
M=D
      HACK
    end
  end
end
