# frozen_string_literal: true

class CodeSpitter
  class EmitBranchingCommand
    def call(command, label_name)
      case command
      when 'label'
        label_instructions(label_name)
      when 'goto'
        goto_instructions(label_name)
      when 'if-goto'
        ifgoto_instructions(label_name)
      end
    end

    private

    def label_instructions(name)
      <<-HACK
(#{name})
      HACK
    end

    def goto_instructions(label_name)
      <<-HACK
@#{label_name}
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

@#{label_name}
D;JGT
      HACK
    end
  end
end
