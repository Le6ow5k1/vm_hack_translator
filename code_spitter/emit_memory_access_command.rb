# frozen_string_literal: true

require_relative 'emit_base'
require_relative 'emit_push_command'
require_relative 'emit_pop_command'

class CodeSpitter
  class EmitMemoryAccessCommand < CodeSpitter::EmitBase
    def initialize
      @emit_push_command = CodeSpitter::EmitPushCommand.new
      @emit_pop_command = CodeSpitter::EmitPopCommand.new
    end

    def call(command, segment, value)
      result = command_comment(command, segment, value)
      result << "\n\n"
      result << command_instructions(command, segment, value)
      result
    end

    private

    def command_instructions(command, segment, value)
      case command
      when 'push'
        @emit_push_command.call(segment, value)
      when 'pop'
        @emit_pop_command.call(segment, value)
      end
    end
  end
end
