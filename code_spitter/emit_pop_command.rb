# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPopCommand
    def call(segment, arg)
      if segment == MemorySegments::POINTER
        return pop_pointer_instructions(arg)
      end

      base_address_label = MemorySegments.segment_to_base_address_label(segment)
      pop_instructions(base_address_label, arg)
    end

    private

    def pop_instructions(base_address_label, step_from_base)
      <<-HACK
#{decrement_sp_instructions}
#{persist_sp_to_d_instructions}
@#{base_address_label}
A=M+#{step_from_base}
M=D
      HACK
    end

    def pop_pointer_instructions(toggle)
      segment_name = MemorySegments.pointer_toggle_to_segment(toggle)

      <<-HACK
#{decrement_sp_instructions}
#{persist_sp_to_d_instructions}
@#{segment_name}
M=D
      HACK
    end

    def decrement_sp_instructions
      <<-HACK
@SP
M=M-1
      HACK
    end

    def persist_sp_to_d_instructions
      <<-HACK
@SP
A=M
D=M
      HACK
    end
  end
end
