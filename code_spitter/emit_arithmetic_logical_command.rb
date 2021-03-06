# frozen_string_literal: true

require_relative 'emit_arithmetic_command'
require_relative 'emit_logical_command'

class CodeSpitter
  class EmitArithmeticLogicalCommand
    def initialize
      super

      @emit_arithmetic_command = EmitArithmeticCommand.new
      @emit_logical_command = EmitLogicalCommand.new
    end

    def call(command)
      send("#{command}_instructions")
    end

    private

    def add_instructions
      @emit_arithmetic_command.call(2, '+')
    end

    def sub_instructions
      @emit_arithmetic_command.call(2, '-')
    end

    def neg_instructions
      @emit_arithmetic_command.call(1, '-')
    end

    def eq_instructions
      @emit_logical_command.call('eq')
    end

    def gt_instructions
      @emit_logical_command.call('gt')
    end

    def lt_instructions
      @emit_logical_command.call('lt')
    end

    def and_instructions
      @emit_arithmetic_command.call(2, '&')
    end

    def or_instructions
      @emit_arithmetic_command.call(2, '|')
    end

    def not_instructions
      @emit_arithmetic_command.call(1, '!')
    end
  end
end
