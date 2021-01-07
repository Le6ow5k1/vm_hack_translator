# frozen_string_literal: true

class CodeSpitter
  class EmitBootstrapCode
    def call
      <<-HACK
@256
D=A

@SP
M=D

#{EmitCallCommand.new.call('Sys.init', 0, 0)}
      HACK
    end
  end
end
