# frozen_string_literal: true

# This class takes a parsed VM command and emits Hack assembly instructions
# that implement that command on the Hack computer
class CodeSpitter
  ARITHMETIC_LOGICAL_COMMANDS = %w[
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

  MEMORY_ACCESS_COMMANDS = %w[
    pop
    push
  ].freeze

  def emit(command:, arg1:, arg2:)
    if ARITHMETIC_LOGICAL_COMMANDS.include?(command)
      EmitArithmeticLogicalCommand.call(command, arg1, arg2)
    elsif MEMORY_ACCESS_COMMANDS.include(command)
      EmitMemoryAccessCommand.call(command, arg1, arg2)
    end
  end
end
