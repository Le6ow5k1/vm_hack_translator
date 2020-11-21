# frozen_string_literal: true

class CodeSpitter
  class EmitArithmeticCommand < CodeSpitter::EmitBase
    def call(args_number, operation)
      case args_number
      when 1 then one_arg_instructions(operation)
      when 2 then two_arg_instructions(operation)
      else raise ArgumentError
      end
    end

    private

    def one_arg_intstructions(operation)
      <<-HACK
@SP
A=M-1
M=#{operation}D
      HACK
    end

    def two_arg_instructions(operation)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=M#{operation}D

@SP
A=M-1
M=D
      HACK
    end
  end
end
