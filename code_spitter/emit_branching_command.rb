# frozen_string_literal: true

class CodeSpitter
  class EmitBranchingCommand < CodeSpitter::EmitBase
    def initialize(file_name)
      @file_name = file_name
    end

    def call(command, arg1, arg2)
      result = command_comment(command, arg1, arg2)
      result << "\n\n"

      result << case command
                when 'label'
                  label_instructions(arg1)
                when 'goto'
                  goto_instructions(arg1)
                when 'if-goto'
                  ifgoto_instructions(arg1)
                end

      result
    end

    private

    def label_instructions(name)
      <<-HACK
(#{output_label_name(name)})
      HACK
    end

    def goto_instructions(label_name)
      <<-HACK
@#{output_label_name(label_name)}
0;JEQ
      HACK
    end

    def ifgoto_instructions(label_name)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@#{output_label_name(label_name)}
D;JGT
      HACK
    end

    def output_label_name(original_label_name)
      "#{@file_name.upcase}_#{original_label_name}"
    end
  end
end
