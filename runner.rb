require_relative 'reader'
require_relative 'parser'
require_relative 'code_spitter'
require_relative 'translator'
require_relative 'writer'
require_relative 'code_spitter/emit_bootstrap_code'

class Runner
  def call(file_path)
    file_or_dir_name = extract_name(file_path)

    translated = [CodeSpitter::EmitBootstrapCode.new.call]
    translated << if File.directory?(file_path)
                    file_paths = Dir.glob("#{file_path}/*.vm")
                    file_paths
                      .map { |p| translate_file(p, file_or_dir_name) }
                      .flatten
                  else
                    translate_file(file_path, file_or_dir_name)
                  end

    Writer.new("#{file_or_dir_name}.asm", translated).call
  end

  private

  def translate_file(file_path, file_name)
    reader = Reader.new(file_path)
    parser = Parser.new(reader)
    code_spitter = CodeSpitter.new(file_name)
    Translator.new(parser, code_spitter).call
  end

  def extract_name(path)
    path.split('/').last.sub(/\.\w*/, '')
  end
end
