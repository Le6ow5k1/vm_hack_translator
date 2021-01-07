# frozen_string_literal: true

class CodeSpitter
  class EmitCallCommand
    def call(function_name:, outer_function_name:, args_number:, call_number:)
      result = +''

      return_label = return_label_name(outer_function_name, call_number)

      result << push(return_label)
      result << push_segment_addr('LCL')
      result << push_segment_addr('ARG')
      result << push_segment_addr('THIS')
      result << push_segment_addr('THAT')
      result << reposition_arg(args_number)
      result << reposition_lcl
      result << goto_function(function_name)
      result << "(#{return_label})\n"

      result
    end

    private

    def push(label_name)
      <<-HACK
@#{label_name}
D=A

#{push_d}
      HACK
    end

    def push_segment_addr(label_name)
      <<-HACK
@#{label_name}
D=M

#{push_d}
      HACK
    end

    def push_d
      <<-HACK
@SP
A=M
M=D

@SP
M=M+1
      HACK
    end

    def reposition_arg(args_number)
      <<-HACK
@5
D=A

@SP
D=M-D

@#{args_number}
D=D-A

@ARG
M=D
      HACK
    end

    def reposition_lcl
      <<-HACK
@SP
D=M

@LCL
M=D
      HACK
    end

    def goto_function(function_name)
      <<-HACK
@#{function_name}
0;JMP
      HACK
    end

    def return_label_name(function_name, call_number)
      "#{function_name}$ret.#{call_number}"
    end
  end
end
