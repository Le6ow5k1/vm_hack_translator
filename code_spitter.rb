# frozen_string_literal: true

require_relative 'code_spitter/emit_arithmetic_logical_command'
require_relative 'code_spitter/emit_memory_access_command'
require_relative 'code_spitter/emit_branching_command'

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

  BRANCHING_COMMANDS = %w[
    label
    goto
    if-goto
  ].freeze

  def initialize(file_name)
    @emit_arithmetic_logical_command = EmitArithmeticLogicalCommand.new
    @emit_memory_access_command = EmitMemoryAccessCommand.new(file_name)
    @emit_branching_command = EmitBranchingCommand.new(file_name)
  end

  def call(command:, arg1:, arg2:)
    result = command_comment(command, arg1, arg2)
    result << "\n\n"

    command_instructions =
      if ARITHMETIC_LOGICAL_COMMANDS.include?(command)
        @emit_arithmetic_logical_command.call(command)
      elsif MEMORY_ACCESS_COMMANDS.include?(command)
        @emit_memory_access_command.call(command, arg1, arg2)
      elsif BRANCHING_COMMANDS.include?(command)
        @emit_branching_command.call(command, arg1)
      end
    result << command_instructions

    result
  end

  private

  def command_comment(command, arg1, arg2)
    +"// #{command} #{arg1} #{arg2}".sub(/\s+\z/, '')
  end
end
