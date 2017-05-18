require 'spec_helper'

RSpec.describe ZendeskSearch::CLI do
  let(:output) { StringIO.new }
  let(:input) { StringIO.new }
  subject { ZendeskSearch::CLI.new(input: input, output: output)}

  def add_input(text)
    input << "#{text}\n"
    input.rewind
  end

  describe 'choose_search_type' do
    it 'can select users' do
      add_input("users")
      selected_option = subject.choose_search_type
      expect(selected_option).to eq(:users)
    end

    it 'can select tickets' do
      add_input("tickets")
      selected_option = subject.choose_search_type
      expect(selected_option).to eq(:tickets)
    end

    it 'can select organisations' do
      add_input("organisations")
      selected_option = subject.choose_search_type
      expect(selected_option).to eq(:organisations)
    end

    it 'can select exit' do
      add_input("exit")
      selected_option = subject.choose_search_type
      expect(selected_option).to eq(:exit)
    end

    context 'invalid option entered' do
      it 'waits for a valid option' do
        add_input("people")
        add_input("users")
        selected_option = subject.choose_search_type
        expect(selected_option).to eq(:users)
      end

      it 'outputs an error message' do
        add_input("people")
        subject.choose_search_type
        expect(output.string).to include('You must choose one of')
      end

      it 'returns exit if there is an error' do
        selected_option = subject.choose_search_type
        expect(selected_option).to eq(:exit)
      end
    end
  end
end
