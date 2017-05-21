require 'spec_helper'

RSpec.describe ZendeskSearch::SearchSource do
  describe 'loading' do
    it 'loads the json file' do
      source = ZendeskSearch::SearchSource.new('example', 'spec/files')
      expect(source.all)
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
      source = ZendeskSearch::SearchSource.new('users', 'data')
      expect(source.all.size).to eq(75)
    end

    it 'loads organisations' do
      source = ZendeskSearch::SearchSource.new('organizations', 'data')
      expect(source.all.size).to eq(25)
    end

    it 'loads tickets' do
      source = ZendeskSearch::SearchSource.new('tickets', 'data')
      expect(source.all.size).to eq(200)
    end
  end

  describe 'search returns all matching' do
    context 'example source' do
      let(:source) do
        ZendeskSearch::SearchSource.new('example', 'spec/files')
      end
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
      let(:source) { ZendeskSearch::SearchSource.new('tickets', 'data') }

      it 'when value is an integer' do
        results = source.search(term: 'submitter_id', value: 1)
        ids = results.map { |ticket| ticket.fetch('_id') }
        expect(ids).to contain_exactly('fc5a8a70-3814-4b17-a6e9-583936fca909',
                                       'cb304286-7064-4509-813e-edc36d57623d')
      end
    end
  end

  describe 'find returns first matching' do
    let(:source) do
      ZendeskSearch::SearchSource.new('example', 'spec/files')
    end
    it 'on _id (number)' do
      results = source.find_first(term: '_id', value: '1')
      expect(results).to eq('_id' => 1,
                            'name' => 'Francisca Rasmussen',
                            'active' => true,
                            'tags' => %w(first example))
    end

    it 'on name (string)' do
      results = source.find_first(term: 'name', value: 'Ingrid Wagner')
      expect(results).to eq('_id' => 3,
                            'name' => 'Ingrid Wagner',
                            'active' => true,
                            'tags' => [])
    end

    it 'on active (boolean)' do
      results = source.find_first(term: 'active', value: 'false')
      expect(results).to eq('_id' => 2,
                            'name' => 'Cross Barlow',
                            'active' => false,
                            'tags' => %w(second example))
    end

    it 'on tags (array of string)' do
      results = source.find_first(term: 'tags', value: 'example')
      expect(results).to eq('_id' => 1,
                            'name' => 'Francisca Rasmussen',
                            'active' => true,
                            'tags' => %w(first example))
    end
  end
end
