# frozen_string_literal: true

class Translator
  def initialize(parser, code_spitter)
    @parser = parser
    @code_spitter = code_spitter
  end

  def call
    instructions = []
    @parser.each do |command_attrs|
      instructions << @code_spitter.call(command_attrs)
    end

    instructions
  end
end
