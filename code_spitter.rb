# frozen_string_literal: true

require_relative 'code_spitter/emit_arithmetic_logical_command'
require_relative 'code_spitter/emit_memory_access_command'

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

  def initialize(file_path)
    @file_path = file_path
    @emit_arithmetic_logical_command = EmitArithmeticLogicalCommand.new
    @emit_memory_access_command = EmitMemoryAccessCommand.new(file_name)
  end

  def call(command:, arg1:, arg2:)
    if ARITHMETIC_LOGICAL_COMMANDS.include?(command)
      @emit_arithmetic_logical_command.call(command, arg1, arg2)
    elsif MEMORY_ACCESS_COMMANDS.include?(command)
      @emit_memory_access_command.call(command, arg1, arg2)
    end
  end

  private

  def file_name
    @file_name ||= @file_path.split('/').last
  end
end
