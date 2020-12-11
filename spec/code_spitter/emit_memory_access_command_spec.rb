require 'spec_helper'

require_relative '../../code_spitter/emit_memory_access_command'

describe CodeSpitter::EmitMemoryAccessCommand do
  describe '#call' do
    subject(:call) { described_class.new(file_name).call(command, arg1, arg2) }

    let(:file_name) { nil }
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

    context 'push local 3' do
      let(:command) { 'push' }
      let(:arg1) { 'local' }
      let(:arg2) { '3' }
      let(:expected_instructions) do
      <<-HACK
// push local 3

@LCL
A=M+3
D=M

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

    context 'push temp 1' do
      let(:command) { 'push' }
      let(:arg1) { 'temp' }
      let(:arg2) { '1' }
      let(:expected_instructions) do
      <<-HACK
// push temp 1

@5
A=M+1
D=M

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

    context 'push pointer 0' do
      let(:command) { 'push' }
      let(:arg1) { 'pointer' }
      let(:arg2) { '0' }
      let(:expected_instructions) do
      <<-HACK
// push pointer 0

@THIS
D=M

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

    context 'push pointer 1' do
      let(:command) { 'push' }
      let(:arg1) { 'pointer' }
      let(:arg2) { '1' }
      let(:expected_instructions) do
      <<-HACK
// push pointer 1

@THAT
D=M

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

    context 'push static 1' do
      let(:command) { 'push' }
      let(:file_name) { 'Foo.vm' }
      let(:arg1) { 'static' }
      let(:arg2) { '1' }
      let(:expected_instructions) do
      <<-HACK
// push static 1

@Foo.1
D=M

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

    context 'pop arg 11' do
      let(:command) { 'pop' }
      let(:arg1) { 'argument' }
      let(:arg2) { '11' }
      let(:expected_instructions) do
      <<-HACK
// pop argument 11

@SP
M=M-1

@SP
A=M
D=M

@ARG
A=M+11
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'pop temp 2' do
      let(:command) { 'pop' }
      let(:arg1) { 'temp' }
      let(:arg2) { '2' }
      let(:expected_instructions) do
      <<-HACK
// pop temp 2

@SP
M=M-1

@SP
A=M
D=M

@5
A=M+2
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'pop pointer 0' do
      let(:command) { 'pop' }
      let(:arg1) { 'pointer' }
      let(:arg2) { '0' }
      let(:expected_instructions) do
      <<-HACK
// pop pointer 0

@SP
M=M-1

@SP
A=M
D=M

@THIS
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'pop pointer 1' do
      let(:command) { 'pop' }
      let(:arg1) { 'pointer' }
      let(:arg2) { '1' }
      let(:expected_instructions) do
      <<-HACK
// pop pointer 1

@SP
M=M-1

@SP
A=M
D=M

@THAT
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end

    context 'pop static 1' do
      let(:command) { 'pop' }
      let(:file_name) { 'hello_world.vm' }
      let(:arg1) { 'static' }
      let(:arg2) { '1' }
      let(:expected_instructions) do
      <<-HACK
// pop static 1

@SP
M=M-1

@SP
A=M
D=M

@Hello_world.1
M=D
      HACK
      end

      it do
        is_expected.to eq(expected_instructions)
      end
    end
  end
end
