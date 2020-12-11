# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPushCommand
    def call(segment, arg)
      case segment
      when MemorySegments::CONSTANT
        return push_constant_instructions(arg)
      when MemorySegments::POINTER
        return push_pointer_instructions(arg)
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

#{persist_d_to_sp_instructions}
#{advance_sp_instructions}
      HACK
    end

    def push_constant_instructions(value)
      <<-HACK
@#{value}
D=A

#{persist_d_to_sp_instructions}
#{advance_sp_instructions}
      HACK
    end

    def push_pointer_instructions(toggle)
      segment_name = MemorySegments.pointer_toggle_to_segment(toggle)

      <<-HACK
@#{segment_name}
D=M

#{persist_d_to_sp_instructions}
#{advance_sp_instructions}
      HACK
    end

    def persist_d_to_sp_instructions
      <<-HACK
@SP
A=M
M=D
      HACK
    end

    def advance_sp_instructions
      "@SP
M=M+1"
    end
  end
end
