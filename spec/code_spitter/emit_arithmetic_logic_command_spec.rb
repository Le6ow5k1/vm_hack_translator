require 'spec_helper'

require_relative '../../code_spitter/emit_arithmetic_logic_command'

describe CodeSpitter::EmitArithmeticLogicCommand do
  describe '#call' do
    subject(:call) { described_class.new.call(command, arg1, arg2) }

    let(:arg1) { nil }
    let(:arg2) { nil }

    context 'add command' do
      let(:command) { 'add' }
      let(:expected_instructions) do
      <<-HACK
// #{command} #{arg1} #{arg2}

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=M+D

@SP
A=M-1
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
