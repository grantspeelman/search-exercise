require 'spec_helper'

RSpec.describe ZendeskSearch::SearchSource do
  it 'loads the json file' do
    source = ZendeskSearch::SearchSource.new('example',
                                             source_directory: 'spec/files')
    expect(source)
      .to contain_exactly({ '_id' => 1,
                            'name' => 'Francisca Rasmussen',
                            'active' => true,
                            'tags' => %w(first example) },
                          { '_id' => 2,
                            'name' => 'Cross Barlow',
                            'active' => false,
                            'tags' => %w(second example) },
                          '_id' => 3,
                          'name' => 'Ingrid Wagner',
                          'active' => true,
                          'tags' => [])
  end

  it 'loads users' do
    source = ZendeskSearch::SearchSource.new('users')
    expect(source.entries.size).to eq(75)
  end

  it 'loads organisations' do
    source = ZendeskSearch::SearchSource.new('organizations')
    expect(source.entries.size).to eq(25)
  end

  it 'loads tickets' do
    source = ZendeskSearch::SearchSource.new('tickets')
    expect(source.entries.size).to eq(200)
  end
end
