require 'spec_helper'

RSpec.describe ZendeskSearch::UserInput do
  let(:input) { StringIO.new('', 'r') }
  let(:highline) { HighLine.new(input, StringIO.new) }
  subject { ZendeskSearch::UserInput.new(highline) }

  def enters(*texts)
    input.string = texts.join("\n")
    input.rewind
  end

  def selections
    array = []
    subject.each do |selection|
      array << selection
    end
    array
  end

  def request(type, term, value)
    ZendeskSearch::SearchRequest.new(type: type, term: term, value: value)
  end

  it 'returns user input until exit' do
    enters 'users', '_id', '1', 'exit'
    expect(selections).to contain_exactly(request('users', '_id', '1'))
  end

  it 'returns multiple user inputs until exit' do
    enters 'users', '_id', '1', 'organizations', 'name', 'Enthaze', 'exit'
    expect(selections).to contain_exactly(request('users', '_id', '1'),
                                          request('organizations', 'name', 'Enthaze'))
  end

  it 'returns only full selections if exit on search term' do
    enters 'tickets', 'type', 'task', 'organizations', 'exit'
    expect(selections).to contain_exactly(request('tickets', 'type', 'task'))
  end

  it 'returns only full selections if exit on search value' do
    enters 'tickets', 'type', 'task', 'users', '_id', '1', 'organizations', 'name', 'exit'
    expect(selections).to contain_exactly(request('tickets', 'type', 'task'),
                                          request('users', '_id', '1'))
  end

  it 'ignores search_type until valid option selected' do
    enters 'people', 'admins', 'users', '_id', '1', 'exit'
    expect(selections).to contain_exactly(request('users', '_id', '1'))
  end
end
