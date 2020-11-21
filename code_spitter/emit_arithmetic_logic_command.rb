# frozen_string_literal: true

require_relative 'emit_base'
require_relative 'emit_arithmetic_command'
require_relative 'emit_compare_command'

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

    def call(command, arg1, arg2)
      raise ArgumentError unless COMMANDS.include?(command)

      result = command_comment(command, arg1, arg2)
      result << "\n\n"
      result << send("#{command}_instructions")
      result
    end

    private

    def add_instructions
      EmitArithmeticCommand.new.call(2, '+')
    end

    def sub_instructions
      EmitArithmeticCommand.new.call(2, '-')
    end

    def neg_instructions
      EmitArithmeticCommand.new.call(1, '-')
    end

    def eq_instructions
      EmitCompareCommand.new.call('gt')
    end

    def gt_instructions
      EmitCompareCommand.new.call('gt')
    end

    def lt_instructions
      EmitCompareCommand.new.call('gt')
    end

    def and_instructions
      EmitArithmeticCommand.new.call(2, '&')
    end

    def or_instructions
      EmitArithmeticCommand.new.call(2, '|')
    end

    def not_instructions
      EmitArithmeticCommand.new.call(1, '!')
    end
  end
end
