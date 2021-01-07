# frozen_string_literal: true

class CodeSpitter
  class EmitBootstrapCode
    def call
      <<-HACK
@256
D=A

@SP
M=D


// call Sys.init 0

#{call_sys_init}
      HACK
    end

    private

    def call_sys_init
      EmitCallCommand.new.call(
        function_name: 'Sys.init',
        outer_function_name: 'global',
        args_number: 0,
        call_number: 0
      )
    end
  end
end
