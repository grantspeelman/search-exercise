require 'spec_helper'

RSpec.describe ZendeskSearch::ResultsDisplayer do
  let(:output) { StringIO.new('', 'w') }
  let(:highline) { HighLine.new(StringIO.new, output) }
  subject { ZendeskSearch::ResultsDisplayer.new(highline) }

  it 'shows search result with main attributes' do
    result = instance_double('ZendeskSearch::SearchResult',
                             attributes: { 'name' => 'bob', 'surname' => 'Jack' })
    subject.show_results([result])
    expect(output.string).to eq("name : bob\nsurname : Jack\n")
  end

  it 'can display multiple results' do
    result1 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { 'name' => 'billy', 'surname' => 'bob' })
    result2 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { 'name' => 'mac', 'surname' => 'James' })
    subject.show_results([result1, result2])
    expect(output.string).to eq("name : billy\nsurname : bob\n" \
                                "----------\n" \
                                "name : mac\nsurname : James\n")
  end

  it 'can display value of type array' do
    result1 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { 'tags' => [] })
    result2 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { 'tags' => %w(one two) })
    subject.show_results([result1, result2])
    expect(output.string).to eq("tags : \n" \
                                "----------\n" \
                                "tags : one, two\n")
  end

  it 'can display associated data' do
    assocation = ZendeskSearch::AssociationDescription.new(name: 'owner',
                                                           associate_source: 'blah',
                                                           associate_term: 'blah',
                                                           term: 'blah')
    result1 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { assocation => [{ 'name' => 'hello' },
                                                           { 'name' => 'good' }] })
    result2 = instance_double('ZendeskSearch::SearchResult',
                              attributes: { assocation => [{ 'subject' => 'other' }] })
    subject.show_results([result1, result2])
    expect(output.string).to eq("owner 0 : hello\n" \
                                "owner 1 : good\n" \
                                "----------\n" \
                                "owner 0 : other\n")
  end
end
