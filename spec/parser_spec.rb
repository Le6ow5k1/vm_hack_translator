require 'spec_helper'

require_relative '../parser'

describe Parser do
  let(:parser) do
    described_class.new(nil)
  end

  describe '#parse_line' do
    subject(:parse_line) { parser.parse_line(line) }

    context 'add command' do
      let(:line) { '  add ' }

      it do
        is_expected.to eq(command: 'add', arg1: nil, arg2: nil)
      end
    end

    context 'or command' do
      let(:line) { 'or' }

      it do
        is_expected.to eq(command: 'or', arg1: nil, arg2: nil)
      end
    end

    context 'pop constant command' do
      let(:line) { ' pop constant 1' }

      it do
        is_expected.to eq(command: 'pop', arg1: 'constant', arg2: '1')
      end
    end

    context 'push local command' do
      let(:line) { ' push local 11' }

      it do
        is_expected.to eq(command: 'push', arg1: 'local', arg2: '11')
      end
    end
  end
end
