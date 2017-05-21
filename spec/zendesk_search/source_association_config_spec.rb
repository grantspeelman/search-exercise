require 'spec_helper'

RSpec.describe ZendeskSearch::SourceAssociationConfig do
  describe '#for' do
    it 'returns ticket mappings' do
      expected_associated_mappings = [
        { name: 'organization',
          associate_source: 'organizations',
          associate_term: '_id',
          term: 'organization_id',
          display: 'name' },
        {
          name: 'submitter',
          associate_source: 'users',
          associate_term: '_id',
          term: 'submitter_id',
          display: 'name'
        },
        {
          name: 'assignee',
          associate_source: 'users',
          associate_term: '_id',
          term: 'assignee_id',
          display: 'name'
        }
      ]
      expect(subject.for('tickets')).to match_array(expected_associated_mappings)
    end

    it 'returns organizations mappings' do
      expected_associated_mappings = [
        { name: 'user',
          associate_source: 'users',
          associate_term: 'organization_id',
          term: '_id',
          display: 'name' }
      ]
      expect(subject.for('organizations')).to match_array(expected_associated_mappings)
    end

    it 'returns users mappings' do
      expected_associated_mappings = [
        { name: 'organization',
          associate_source: 'organizations',
          associate_term: '_id',
          term: 'organization_id',
          display: 'name' },
        { name: 'submitted ticket',
          associate_source: 'tickets',
          associate_term: 'submitter_id',
          term: '_id',
          display: 'subject' },
        { name: 'assigned ticket',
          associate_source: 'tickets',
          associate_term: 'assignee_id',
          term: '_id',
          display: 'subject' }
      ]
      expect(subject.for('users')).to match_array(expected_associated_mappings)
    end

    it 'returns empty array by default' do
      expect(subject.for('people')).to eq([])
      expect(subject.for('other')).to eq([])
      expect(subject.for('')).to eq([])
    end
  end
end
