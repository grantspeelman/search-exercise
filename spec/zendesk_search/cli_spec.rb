require 'spec_helper'

RSpec.describe ZendeskSearch::CLI do
  let(:user_input) { [] }
  let(:results_displayer) { DummyResultsdisplayer.new }
  let(:searcher) { instance_double('ZendeskSearch::Searcher', search: 'searched') }

  class DummyResultsdisplayer
    attr_reader :show_results

    def show(results)
      @show_results = results
    end
  end

  subject do
    ZendeskSearch::CLI.new(user_input: user_input,
                           results_displayer: results_displayer,
                           searcher: searcher)
  end

  it 'sends input for search' do
    request = double('Request')
    expect(searcher).to receive(:search).with(request)
    user_input << request
    subject.run
  end

  it 'sends search results to displayer' do
    request = double('Request')
    user_input << request
    results = double('SearchResults')
    allow(searcher).to receive(:search).and_return(results)

    expect(results_displayer).to receive(:show).with(results)
    subject.run
  end
end
