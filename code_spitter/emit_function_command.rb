# frozen_string_literal: true

class CodeSpitter
  class EmitFunctionCommand
    def call(function_name, locals_number)
      result = +"(#{function_name})\n"
      Integer(locals_number).times do
        result << push_zero_instructions
      end

      result
    end

    private

    def push_zero_instructions
      <<-HACK
@SP
A=M
M=0

@SP
M=M+1
      HACK
    end
  end
end
