require 'spec_helper'

RSpec.describe ZendeskSearch::SearchSource do
  describe 'loading' do
    it 'loads the json file' do
      source = ZendeskSearch::SearchSource.new('example',
                                               source_directory: 'spec/files')
      expect(source)
        .to match_array([{ '_id' => 1,
                           'name' => 'Francisca Rasmussen',
                           'active' => true,
                           'tags' => %w(first example) },
                         { '_id' => 2,
                           'name' => 'Cross Barlow',
                           'active' => false,
                           'tags' => %w(second example) },
                         { '_id' => 3,
                           'name' => 'Ingrid Wagner',
                           'active' => true,
                           'tags' => [] }])
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

  describe 'search returns all matching' do
    context 'example source' do
      let(:source) { ZendeskSearch::SearchSource.new('example',
                                                     source_directory: 'spec/files') }
      it 'on _id (number)' do
        results = source.search(term: '_id', value: '1')
        expect(results).to contain_exactly('_id' => 1,
                                           'name' => 'Francisca Rasmussen',
                                           'active' => true,
                                           'tags' => %w(first example))
      end

      it 'on name (string)' do
        results = source.search(term: 'name', value: 'Ingrid Wagner')
        expect(results).to contain_exactly('_id' => 3,
                                           'name' => 'Ingrid Wagner',
                                           'active' => true,
                                           'tags' => [])
      end

      it 'on active (boolean)' do
        results = source.search(term: 'active', value: 'false')
        expect(results).to contain_exactly('_id' => 2,
                                           'name' => 'Cross Barlow',
                                           'active' => false,
                                           'tags' => %w(second example))
      end

      it 'on tags (array of string)' do
        results = source.search(term: 'tags', value: 'example')
        expect(results).to match_array([{ '_id' => 1,
                                              'name' => 'Francisca Rasmussen',
                                              'active' => true,
                                              'tags' => %w(first example) },
                                            { '_id' => 2,
                                              'name' => 'Cross Barlow',
                                              'active' => false,
                                              'tags' => %w(second example) }])
      end
    end

    context 'tickets' do
      let(:source) { ZendeskSearch::SearchSource.new('tickets') }

      it 'when value is an integer' do
        results = source.search(term: 'submitter_id', value: 1)
        ids = results.map{ |ticket| ticket.fetch('_id') }
        expect(ids).to contain_exactly('fc5a8a70-3814-4b17-a6e9-583936fca909',
                                       'cb304286-7064-4509-813e-edc36d57623d')
      end
    end
  end
end
