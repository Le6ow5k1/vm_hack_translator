# frozen_string_literal: true

class Writer
  def initialize(file_path, instructions)
    @file_path = file_path
    @instructions = instructions
  end

  def call
    separated_instructions = @instructions.product(["\n\n"]).flatten!
    separated_instructions.pop

    File.open(@file_path, 'w+') do |f|
      f.puts(separated_instructions)
    end
  end
end
