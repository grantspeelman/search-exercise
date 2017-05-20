require 'spec_helper'

RSpec.describe ZendeskSearch::ResultsDisplayer do
  let(:output) { StringIO.new('', 'w') }
  let(:highline) { HighLine.new(StringIO.new, output) }
  subject { ZendeskSearch::ResultsDisplayer.new(highline) }

  it 'displays single array of hash' do
    subject.show([{ 'name' => 'bob', 'surname' => 'Jack' }])
    expect(output.string).to eq("name : bob\nsurname : Jack\n")
  end

  it 'can display multiple results' do
    subject.show([{ 'name' => 'billy', 'surname' => 'bob' },
                  { 'name' => 'mac', 'surname' => 'James' }])
    expect(output.string).to eq("name : billy\nsurname : bob\n" \
                                "----------\n" \
                                "name : mac\nsurname : James\n")
  end

  it 'can display value of type array' do
    subject.show([{ 'tags' => [] }, { 'tags' => %w(one two) }])
    expect(output.string).to eq("tags : \n" \
                                "----------\n" \
                                "tags : one, two\n")
  end
end
