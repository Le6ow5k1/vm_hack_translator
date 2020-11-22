# frozen_string_literal: true

require_relative 'emit_base'
require_relative 'emit_arithmetic_command'
require_relative 'emit_logic_command'

class CodeSpitter
  class EmitArithmeticLogicCommand < CodeSpitter::EmitBase
    COMMANDS = %w[
      add
      sub
      neg
      eq
      gt
      lt
      and
      or
      not
    ].freeze

    def initialize
      @emit_arithmetic_command = EmitArithmeticCommand.new
      @emit_logic_command = EmitLogicCommand.new
    end

    def call(command, arg1, arg2)
      raise ArgumentError unless COMMANDS.include?(command)

      result = command_comment(command, arg1, arg2)
      result << "\n\n"
      result << send("#{command}_instructions")
      result
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
      @emit_logic_command.call('eq')
    end

    def gt_instructions
      @emit_logic_command.call('gt')
    end

    def lt_instructions
      @emit_logic_command.call('lt')
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
