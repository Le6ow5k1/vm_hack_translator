# frozen_string_literal: true

class Reader
  def initialize(file_path)
    @file_path = file_path
  end

  def each
    File.readlines(@file_path).each do |line|
      yield line
    end
  end
end
