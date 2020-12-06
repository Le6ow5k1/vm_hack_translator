require_relative 'runner'

file_path = ARGV.first

raise if !file_path

Runner.new.call(file_path)
