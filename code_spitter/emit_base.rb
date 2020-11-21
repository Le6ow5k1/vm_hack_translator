# frozen_string_literal: true

class CodeSpitter
  class EmitBase
    private

    def command_comment(command, arg1, arg2)
      +"// #{command} #{arg1} #{arg2}"
    end
  end
end
