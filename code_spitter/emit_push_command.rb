# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPushCommand
    def initialize(file_name)
      @file_name = file_name
    end

    def call(segment, arg)
      case segment
      when MemorySegments::CONSTANT
        push_constant_instructions(arg)
      when MemorySegments::POINTER
        push_pointer_instructions(arg)
      when MemorySegments::STATIC
        push_static_instructions(arg)
      else
        base_address_label = MemorySegments.segment_to_base_address_label(segment)

        case segment
        when MemorySegments::TEMP
          push_temp_instructions(base_address_label, arg)
        else
          push_instructions(base_address_label, arg)
        end
      end
    end

    private

    def push_instructions(base_address_label, step_from_base)
      <<-HACK
@#{base_address_label}
D=M
@#{step_from_base}
A=D+A
D=M

#{persist_d_to_sp_instructions}
#{advance_sp_instructions}
      HACK
    end

    def push_temp_instructions(base_address_label, step_from_base)
      <<-HACK
@#{base_address_label}
D=A
@#{step_from_base}
A=D+A
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

    def push_static_instructions(step_from_base)
      var_name = MemorySegments.build_static_var_name(@file_name, step_from_base)

      <<-HACK
@#{var_name}
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
