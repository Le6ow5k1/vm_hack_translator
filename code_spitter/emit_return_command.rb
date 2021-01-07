# frozen_string_literal: true

class CodeSpitter
  class EmitReturnCommand
    def call
      result = +''

      result << save_end_frame_address
      result << save_return_address
      result << reposition_return_value
      result << reposition_sp

      result << restore_segment('THAT', 1)
      result << restore_segment('THIS', 2)
      result << restore_segment('ARG', 3)
      result << restore_segment('LCL', 4)

      result << goto_return_address

      result
    end

    private

    def save_end_frame_address
      <<-HACK
@LCL
D=M

@R13
M=D
      HACK
    end

    def save_return_address
      <<-HACK
@R13
D=M

@5
A=D-A
D=M

@R14
M=D
      HACK
    end

    def reposition_return_value
      <<-HACK
@SP
M=M-1
A=M
D=M

@ARG
A=M
M=D
      HACK
    end

    def reposition_sp
      <<-HACK
@ARG
D=M

@SP
M=D+1
      HACK
    end

    def restore_segment(label_name, step_from_end_frame)
      <<-HACK
@R13
D=M

@#{step_from_end_frame}
A=D-A
D=M

@#{label_name}
M=D
      HACK
    end

    def goto_return_address
      <<-HACK
@R14
A=M
0;JMP
      HACK
    end
  end
end
