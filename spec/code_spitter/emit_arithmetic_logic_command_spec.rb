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
// add

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

    context 'sub command' do
      let(:command) { 'sub' }
      let(:expected_instructions) do
      <<-HACK
// sub

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=M-D

@SP
A=M-1
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'neg command' do
      let(:command) { 'neg' }
      let(:expected_instructions) do
      <<-HACK
// neg

@SP
A=M-1
M=-D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'eq command' do
      let(:command) { 'eq' }
      let(:expected_instructions) do
      <<-HACK
// eq

@SP
A=M-1
D=M

@POSITIVE
D;JEQ

@NEGATIVE
D;JNE

(POSITIVE)
  @SP
  A=M-1
  M=1

(NEGATIVE)
  @SP
  A=M-1
  M=0
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'gt command' do
      let(:command) { 'gt' }
      let(:expected_instructions) do
      <<-HACK
// gt

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=D-M

@POSITIVE
D;JGT

@NEGATIVE
0;JMP

(POSITIVE)
  @SP
  A=M-1
  M=1

(NEGATIVE)
  @SP
  A=M-1
  M=0
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'lt command' do
      let(:command) { 'lt' }
      let(:expected_instructions) do
      <<-HACK
// lt

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=D-M

@POSITIVE
D;JLT

@NEGATIVE
0;JMP

(POSITIVE)
  @SP
  A=M-1
  M=1

(NEGATIVE)
  @SP
  A=M-1
  M=0
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'and command' do
      let(:command) { 'and' }
      let(:expected_instructions) do
      <<-HACK
// and

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=M&D

@SP
A=M-1
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'or command' do
      let(:command) { 'or' }
      let(:expected_instructions) do
      <<-HACK
// or

@SP
M=M-1

@SP
A=M
D=M

@SP
A=M-1
D=M|D

@SP
A=M-1
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'not command' do
      let(:command) { 'not' }
      let(:expected_instructions) do
      <<-HACK
// not

@SP
A=M-1
M=!D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
