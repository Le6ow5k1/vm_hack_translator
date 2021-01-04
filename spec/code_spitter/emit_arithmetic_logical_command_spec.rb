require 'spec_helper'

require_relative '../../code_spitter/emit_arithmetic_logical_command'

describe CodeSpitter::EmitArithmeticLogicalCommand do
  describe '#call' do
    subject(:call) { described_class.new.call(command) }

    context 'add command' do
      let(:command) { 'add' }
      let(:expected_instructions) do
      <<-HACK
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
@SP
M=M-1

@SP
A=M
D=M

@SP
M=M-1

@SP
A=M

D=M-D

@POSITIVE1
D;JEQ

@NEGATIVE1
D;JNE

(NEGATIVE1)
  @SP
  A=M
  M=0

  @SP
  M=M+1

  @FINISH1
  0;JMP

(POSITIVE1)
  @SP
  A=M
  M=-1

  @SP
  M=M+1

  @FINISH1
  0;JMP

(FINISH1)
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
@SP
M=M-1

@SP
A=M
D=M

@SP
M=M-1

@SP
A=M

D=M-D

@POSITIVE1
D;JGT

@NEGATIVE1
D;JLE

(NEGATIVE1)
  @SP
  A=M
  M=0

  @SP
  M=M+1

  @FINISH1
  0;JMP

(POSITIVE1)
  @SP
  A=M
  M=-1

  @SP
  M=M+1

  @FINISH1
  0;JMP

(FINISH1)
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
@SP
M=M-1

@SP
A=M
D=M

@SP
M=M-1

@SP
A=M

D=M-D

@POSITIVE1
D;JLT

@NEGATIVE1
D;JGE

(NEGATIVE1)
  @SP
  A=M
  M=0

  @SP
  M=M+1

  @FINISH1
  0;JMP

(POSITIVE1)
  @SP
  A=M
  M=-1

  @SP
  M=M+1

  @FINISH1
  0;JMP

(FINISH1)
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
