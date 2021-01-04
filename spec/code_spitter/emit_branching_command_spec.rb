require 'spec_helper'

require_relative '../../code_spitter/emit_branching_command'

describe CodeSpitter::EmitBranchingCommand do
  describe '#call' do
    subject(:call) { described_class.new(file_name).call(command, arg1) }

    let(:file_name) { 'some_file' }
    let(:arg1) { nil }

    context 'label' do
      let(:command) { 'label' }
      let(:arg1) { 'ABC' }
      let(:expected_instructions) do
      <<-HACK
(SOME_FILE_ABC)
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'goto' do
      let(:command) { 'goto' }
      let(:arg1) { 'ABC' }
      let(:expected_instructions) do
      <<-HACK
@SOME_FILE_ABC
0;JEQ
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'if-goto' do
      let(:command) { 'if-goto' }
      let(:arg1) { 'ABC' }
      let(:expected_instructions) do
      <<-HACK
@SP
M=M-1

@SP
A=M
D=M

@SOME_FILE_ABC
D;JGT
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
