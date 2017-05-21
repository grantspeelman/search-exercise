require 'spec_helper'

RSpec.describe ZendeskSearch::AssociationDescription do
  it 'sets values' do
    description = ZendeskSearch::AssociationDescription.new(name: 'user',
                                                            associate_source: 'users',
                                                            associate_term: 'organization_id',
                                                            term: '_id')
    expect(description.name).to eq('user')
    expect(description.associate_source).to eq('users')
    expect(description.associate_term).to eq('organization_id')
    expect(description.term).to eq('_id')
  end
end
