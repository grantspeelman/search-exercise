require 'spec_helper'

RSpec.describe ZendeskSearch::SearchResult do
  it 'sets the main attributes' do
    results = ZendeskSearch::SearchResult.new('id' => 1,
                                              'name' => 'Gman',
                                              'alive' => true,
                                              'skills' => ['swimming', 'dancing'])
    expect(results.attributes).to eq('id' => 1,
                                     'name' => 'Gman',
                                     'alive' => true,
                                     'skills' => ['swimming', 'dancing'])
  end
end
