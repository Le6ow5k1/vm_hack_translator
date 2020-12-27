# frozen_string_literal: true

require_relative 'memory_segments'

class CodeSpitter
  class EmitPopCommand
    def initialize(file_name)
      @file_name = file_name
    end

    def call(segment, arg)
      case segment
      when MemorySegments::POINTER
        pop_pointer_instructions(arg)
      when MemorySegments::STATIC
        pop_static_instructions(arg)
      else
        base_address_label = MemorySegments.segment_to_base_address_label(segment)

        case segment
        when MemorySegments::TEMP
          pop_temp_instructions(base_address_label, arg)
        else
          pop_instructions(base_address_label, arg)
        end
      end
    end

    private

    def pop_instructions(base_address_label, step_from_base)
      <<-HACK
@#{base_address_label}
D=M
@#{step_from_base}
D=D+A

@R13
M=D

#{write_sp_to_d_instructions(true)}
#{write_d_to_r_instructions(13)}
#{decrement_sp_instructions.sub(/\s$/, '')}
      HACK
    end

    def pop_temp_instructions(base_address_label, step_from_base)
      <<-HACK
@#{base_address_label}
D=A
@#{step_from_base}
D=D+A

@R13
M=D

#{write_sp_to_d_instructions(true)}
#{write_d_to_r_instructions(13)}
#{decrement_sp_instructions.sub(/\s$/, '')}
      HACK
    end

    def pop_pointer_instructions(toggle)
      segment_name = MemorySegments.pointer_toggle_to_segment(toggle)

      <<-HACK
#{decrement_sp_instructions}
#{write_sp_to_d_instructions}
@#{segment_name}
M=D
      HACK
    end

    def pop_static_instructions(step_from_base)
      var_name = MemorySegments.build_static_var_name(@file_name, step_from_base)

      <<-HACK
#{decrement_sp_instructions}
#{write_sp_to_d_instructions}
@#{var_name}
M=D
      HACK
    end

    def decrement_sp_instructions
      <<-HACK
@SP
M=M-1
      HACK
    end

    def write_sp_to_d_instructions(decrement_sp = false)
      set_a_register = decrement_sp ? 'A=M-1' : 'A=M'

      <<-HACK
@SP
#{set_a_register}
D=M
      HACK
    end

    def write_d_to_r_instructions(register_number)
      <<-HACK
@R#{register_number}
A=M
M=D
      HACK
    end
  end
end
