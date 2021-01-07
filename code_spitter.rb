# frozen_string_literal: true

require_relative 'code_spitter/emit_arithmetic_logical_command'
require_relative 'code_spitter/emit_memory_access_command'
require_relative 'code_spitter/emit_branching_command'
require_relative 'code_spitter/emit_function_command'
require_relative 'code_spitter/emit_call_command'
require_relative 'code_spitter/emit_return_command'

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

  FUNCTION_COMMAND = 'function'
  CALL_COMMAND = 'call'
  RETURN_COMMAND = 'return'

  def initialize(file_name)
    @emit_arithmetic_logical_command = EmitArithmeticLogicalCommand.new
    @emit_memory_access_command = EmitMemoryAccessCommand.new(file_name)
    @emit_branching_command = EmitBranchingCommand.new
    @emit_function_command = EmitFunctionCommand.new
    @emit_call_command = EmitCallCommand.new
    @emit_return_command = EmitReturnCommand.new

    @current_function_name = nil
    @function_call_number = 0
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
        @emit_branching_command.call(command, arg1, @current_function_name)
      elsif command == FUNCTION_COMMAND
        @current_function_name = arg1
        @function_call_number = 0
        @emit_function_command.call(arg1, arg2)
      elsif command == CALL_COMMAND
        call_result = @emit_call_command.call(
          function_name: arg1,
          outer_function_name: @current_function_name,
          args_number: arg2,
          call_number: @function_call_number
        )
        @function_call_number += 1
        call_result
      elsif command == RETURN_COMMAND
        @emit_return_command.call
      end
    result << command_instructions
    result << "\n\n"

    result
  end

  private

  def command_comment(command, arg1, arg2)
    +"// #{command} #{arg1} #{arg2}".sub(/\s+\z/, '')
  end
end
