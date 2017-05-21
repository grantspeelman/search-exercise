require 'spec_helper'

RSpec.describe ZendeskSearch::SearchResult do
  it 'sets the main attributes' do
    results = ZendeskSearch::SearchResult.new('id' => 1,
                                              'name' => 'Gman',
                                              'alive' => true,
                                              'skills' => %w(swimming dancing))
    expect(results.attributes).to eq('id' => 1,
                                     'name' => 'Gman',
                                     'alive' => true,
                                     'skills' => %w(swimming dancing))
  end

  it 'allows to set new attributes' do
    results = ZendeskSearch::SearchResult.new('id' => 456)
    results['food'] = 'meat'
    expect(results.attributes).to eq('id' => 456,
                                     'food' => 'meat')
  end
end
