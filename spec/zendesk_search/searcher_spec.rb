require 'spec_helper'

RSpec.describe ZendeskSearch::Searcher do
  let(:association_config) do
    instance_double('ZendeskSearch::SourceAssociationConfig', descriptions_for: [])
  end

  let(:association_config_class) { double('SourceAssociationConfig', new: association_config) }

  subject do
    ZendeskSearch::Searcher.new(source_directory: 'spec/files',
                                association_config_class: association_config_class)
  end

  def request(type, term, value)
    ZendeskSearch::SearchRequest.new(type: type, term: term, value: value)
  end

  it 'finds users as is without assocations' do
    org_assocation = ZendeskSearch::AssociationDescription.new(name: 'organization',
                                                               associate_source: 'organizations',
                                                               associate_term: '_id',
                                                               term: 'organization_id')
    org_result = ZendeskSearch::SearchResult.new('_id' => 1, 'name' => 'Zendesk')

    results = subject.search(request('users', '_id', '1'))
    expect(results.size).to eq(1)
    first_result = results.first
    expect(first_result.attributes)
      .to eq('_id' => 1,
             'organization_id' => 1,
             'name' =>  'Francisca Rasmussen',
             'active' => true,
             'tags' => %w(first example))
  end

  it 'finds user on _id and maps associations' do
    org_assocation = ZendeskSearch::AssociationDescription.new(name: 'organization',
                                                               associate_source: 'organizations',
                                                               associate_term: '_id',
                                                               term: 'organization_id')
    expect(association_config).to receive(:descriptions_for).and_return([org_assocation])

    results = subject.search(request('users', '_id', '1'))
    expect(results.size).to eq(1)
    first_result = results.first
    expect(first_result.attributes)
      .to eq('_id' => 1,
             'organization_id' => 1,
             'name' =>  'Francisca Rasmussen',
             'active' => true,
             'tags' => %w(first example),
             org_assocation => [{ '_id' => 1, 'name' => 'Zendesk' }])
  end

  it 'finds multiple users on organization_id' do
    results = subject.search(request('users', 'organization_id', '1'))
    ids = results.map { |result| result.fetch('_id') }
    expect(ids).to contain_exactly(1, 2, 3)
  end

  it 'finds organizations' do
    results = subject.search(request('organizations', '_id', '1'))
    expect(results.size).to eq(1)
    first_result = results.first
    expect(first_result.attributes)
      .to eq('_id' => 1,
             'name' => 'Zendesk')
  end

  it 'finds tickets on subject and maps associations' do
    owner_assocation = ZendeskSearch::AssociationDescription.new(name: 'owner',
                                                                 associate_source: 'users',
                                                                 associate_term: '_id',
                                                                 term: 'owner_id')
    org_assocation = ZendeskSearch::AssociationDescription.new(name: 'organization',
                                                               associate_source: 'organizations',
                                                               associate_term: '_id',
                                                               term: 'organization_id')
    expect(association_config).to receive(:descriptions_for).and_return([owner_assocation, org_assocation])

    results = subject.search(request('tickets', 'subject', 'Complete Zendesk Exercise'))
    expect(results.size).to eq(1)
    first_result = results.first
    expect(first_result.attributes)
      .to eq('_id' => '436bf9b0-1147-4c0a-8439-6f79833bff5b',
             'subject' => 'Complete Zendesk Exercise',
             'done' => true,
             'owner_id' => 1,
             'organization_id' => 1,
             'tags' => %w(Job Melbourne),
             owner_assocation => [{ '_id' => 1,
                                    'organization_id' => 1,
                                    'name' =>  'Francisca Rasmussen',
                                    'active' => true,
                                    'tags' => %w(first example) }],
             org_assocation => [{ '_id' => 1,
                                  'name' => 'Zendesk' }])
  end

  it 'returns all the search sources' do
    expect(subject.search_sources).to contain_exactly('example',
                                                      'organizations',
                                                      'tickets',
                                                      'users')
  end

  it 'returns all the search sources in default data directory' do
    searcher = ZendeskSearch::Searcher.new
    expect(searcher.search_sources).to contain_exactly('organizations',
                                                       'tickets',
                                                       'users')
  end
end
