require_relative 'reader'
require_relative 'parser'
require_relative 'code_spitter'
require_relative 'translator'
require_relative 'writer'

class Runner
  def call(file_path)
    translated = if File.directory?(file_path)
                   Dir.glob("#{file_path}/*.vm").map(&method(:translate_file)).flatten
                 else
                   transalate_file(file_path)
                 end

    file_or_dir_name = extract_name(file_path)
    Writer.new("#{file_or_dir_name}.asm", translated).call
  end

  private

  def translate_file(file_path)
    reader = Reader.new(file_path)
    parser = Parser.new(reader)
    code_spitter = CodeSpitter.new(file_path)
    Translator.new(parser, code_spitter).call
  end

  def extract_name(path)
    path.split('/').last.sub(/\.\w*/, '')
  end
end
