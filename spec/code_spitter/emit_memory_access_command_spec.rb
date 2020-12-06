require 'spec_helper'

require_relative '../../code_spitter/emit_memory_access_command'

describe CodeSpitter::EmitMemoryAccessCommand do
  describe '#call' do
    subject(:call) { described_class.new.call(command, arg1, arg2) }

    let(:arg1) { nil }
    let(:arg2) { nil }

    context 'push constant' do
      let(:command) { 'push' }
      let(:arg1) { 'constant' }
      let(:arg2) { '6' }
      let(:expected_instructions) do
      <<-HACK
// push constant 6

@6
D=A

@SP
A=M
M=D

@SP
M=M+1
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
