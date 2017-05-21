require 'spec_helper'

RSpec.describe ZendeskSearch::SourceAssociationConfig do
  describe '#descriptions_for' do
    it 'returns ticket mappings' do
      expected_associated_mappings = [
        { name: 'organization',
          associate_source: 'organizations',
          associate_term: '_id',
          term: 'organization_id' },
        { name: 'submitter',
          associate_source: 'users',
          associate_term: '_id',
          term: 'submitter_id' },
        { name: 'assignee',
          associate_source: 'users',
          associate_term: '_id',
          term: 'assignee_id' }
      ]
      expect(subject.descriptions_for('tickets').map(&:to_h)).to match_array(expected_associated_mappings)
    end

    it 'returns organizations mappings' do
      expected_associated_mappings = [
        { name: 'user',
          associate_source: 'users',
          associate_term: 'organization_id',
          term: '_id' }
      ]
      expect(subject.descriptions_for('organizations').map(&:to_h)).to match_array(expected_associated_mappings)
    end

    it 'returns users mappings' do
      expected_associated_mappings = [
        { name: 'organization',
          associate_source: 'organizations',
          associate_term: '_id',
          term: 'organization_id' },
        { name: 'submitted ticket',
          associate_source: 'tickets',
          associate_term: 'submitter_id',
          term: '_id' },
        { name: 'assigned ticket',
          associate_source: 'tickets',
          associate_term: 'assignee_id',
          term: '_id' }
      ]
      expect(subject.descriptions_for('users').map(&:to_h)).to match_array(expected_associated_mappings)
    end

    it 'returns empty array by default' do
      expect(subject.descriptions_for('people').map(&:to_h)).to eq([])
      expect(subject.descriptions_for('other').map(&:to_h)).to eq([])
      expect(subject.descriptions_for('').map(&:to_h)).to eq([])
    end
  end
end
