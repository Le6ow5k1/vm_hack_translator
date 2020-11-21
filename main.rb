require_relative ''

file_path = ARGV.first

raise if !file_path

reader = Reader.new(file_path)
parser = Parser.new(reader)
code_spitter = CodeSpitter.new
translated = Translator.new(parser, code_spitter).call
Writer.new(translated).call
