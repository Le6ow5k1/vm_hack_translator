# frozen_string_literal: true

require_relative 'emit_push_command'
require_relative 'emit_pop_command'

class CodeSpitter
  class EmitMemoryAccessCommand
    def initialize(file_name)
      @emit_push_command = CodeSpitter::EmitPushCommand.new(file_name)
      @emit_pop_command = CodeSpitter::EmitPopCommand.new(file_name)
    end

    def call(command, segment, value)
      case command
      when 'push'
        @emit_push_command.call(segment, value)
      when 'pop'
        @emit_pop_command.call(segment, value)
      end
    end
  end
end
