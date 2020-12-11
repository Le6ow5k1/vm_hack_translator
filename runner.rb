require_relative 'reader'
require_relative 'parser'
require_relative 'code_spitter'
require_relative 'translator'
require_relative 'writer'

class Runner
  def call(file_path)
    reader = Reader.new(file_path)
    parser = Parser.new(reader)
    code_spitter = CodeSpitter.new(file_path)
    translated = Translator.new(parser, code_spitter).call
    Writer.new("#{file_path}.asm", translated).call
  end
end
