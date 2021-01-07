require 'spec_helper'

require_relative '../../code_spitter/emit_branching_command'

describe CodeSpitter::EmitBranchingCommand do
  describe '#call' do
    subject(:call) { described_class.new.call(command, arg1, function_name) }

    let(:arg1) { nil }
    let(:function_name) { 'foo' }

    context 'label' do
      let(:command) { 'label' }
      let(:arg1) { 'ABC' }
      let(:expected_instructions) do
      <<-HACK
(foo$ABC)
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
@foo$ABC
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

@foo$ABC
D;JGT
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
