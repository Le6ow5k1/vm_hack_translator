require 'spec_helper'

require_relative '../runner'

describe Runner do
  context 'SimpleAdd' do
    let(:file_path) do
      File.join(File.dirname(__FILE__), './fixtures/SimpleAdd.vm')
    end

    it do
      described_class.new.call(file_path)

      output = File.read(file_path + '.asm')
      expected_output = File.read(file_path.sub('.vm', '.expected') + '.asm')

      expect(output).to eq(expected_output)
    end
  end
end
