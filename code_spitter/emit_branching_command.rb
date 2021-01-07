# frozen_string_literal: true

class CodeSpitter
  class EmitBranchingCommand
    def call(command, label_name, function_name = nil)
      case command
      when 'label'
        label_instructions(label_name, function_name)
      when 'goto'
        goto_instructions(label_name, function_name)
      when 'if-goto'
        ifgoto_instructions(label_name, function_name)
      end
    end

    private

    def label_instructions(name, function_name)
      <<-HACK
(#{output_label_name(name, function_name)})
      HACK
    end

    def goto_instructions(label_name, function_name)
      <<-HACK
@#{output_label_name(label_name, function_name)}
0;JEQ
      HACK
    end

    def ifgoto_instructions(label_name, function_name)
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@#{output_label_name(label_name, function_name)}
D;JGT
      HACK
    end

    def output_label_name(original_label_name, function_name)
      "#{function_name}$#{original_label_name}"
    end
  end
end
