# frozen_string_literal: true

class CodeSpitter
  class EmitCompareCommand < CodeSpitter::EmitBase
    def call(command)
      case command
      when 'eq' then eq_instructions
      when 'gt' then two_arg_instructions('JGT')
      when 'lt' then two_arg_instructions('JLT')
      else
        raise ArgumentError
      end
    end

    private

    def eq_instructions
      <<-HACK
@SP
A=M-1
D=M

@POSITIVE
D;JEQ

@NEGATIVE
D;JNE

(POSITIVE)
  @SP
  A=M-1
  M=1

(NEGATIVE)
  @SP
  A=M-1
  M=0
      HACK
    end

    def two_arg_instructions(positive_jmp)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=D-M

@POSITIVE
D;#{positive_jmp}

@NEGATIVE
0;JMP

(POSITIVE)
  @SP
  A=M-1
  M=1

(NEGATIVE)
  @SP
  A=M-1
  M=0
      HACK
    end
  end
end
