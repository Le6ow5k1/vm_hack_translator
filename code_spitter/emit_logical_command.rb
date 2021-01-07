# frozen_string_literal: true

class CodeSpitter
  class EmitLogicalCommand
    def initialize
      @counter = 0
    end

    def call(command)
      @counter += 1

      case command
      when 'eq' then two_arg_instructions('JEQ', 'JNE')
      when 'gt' then two_arg_instructions('JGT', 'JLE')
      when 'lt' then two_arg_instructions('JLT', 'JGE')
      else
        raise ArgumentError
      end
    end

    private

    def two_arg_instructions(positive_jmp, negative_jmp)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@SP
M=M-1

@SP
A=M

D=M-D

@POSITIVE#{@counter}
D;#{positive_jmp}

@NEGATIVE#{@counter}
D;#{negative_jmp}

(NEGATIVE#{@counter})
  @SP
  A=M
  M=0

  @SP
  M=M+1

  @FINISH#{@counter}
  0;JMP

(POSITIVE#{@counter})
  @SP
  A=M
  M=1

  @SP
  M=M+1

  @FINISH#{@counter}
  0;JMP

(FINISH#{@counter})
      HACK
    end
  end
end
