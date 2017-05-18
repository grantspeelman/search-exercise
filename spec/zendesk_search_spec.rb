require 'spec_helper'

RSpec.describe ZendeskSearch do
  it 'has a version number' do
    expect(ZendeskSearch::VERSION).not_to be nil
  end

  describe 'searching' do
    let(:output) { StringIO.new }
    let(:input) { StringIO.new }
    subject { ZendeskSearch::CLI.new(input: input, output: output)}

    def enters(text)
      input << "#{text}\n"
      input.rewind
    end

    context 'users' do
      before do
        enters 'users'
      end

      it 'finds user on id' do
        pending
        enters '_id'
        enters '1'
        enters 'exit'
        output_lines = output.readlines.map(&:chomp)
        expected_output_array_lines = [['_id', '1'],
                                       ['url', 'http://initech.zendesk.com/api/v2/users/1.json'],
                                       ['external_id', '74341f74-9c79-49d5-9611-87ef9b6eb75f'],
                                       ['name', 'Francisca Rasmussen'],
                                       ['alias', 'Miss Coffey'],
                                       ['created_at', '2016-04-15T05:19:46 -10:00'],
                                       ['active', 'true'],
                                       ['verified', 'true'],
                                       ['shared', 'false'],
                                       ['locale', 'en-AU'],
                                       ['timezone', 'Sri Lanka'],
                                       ['last_login_at', '2013-08-04T01:03:27 -10:00'],
                                       ['email', 'coffeyrasmussen@flotonic.com'],
                                       ['phone', '8335-422-718'],
                                       ['signature', 'Don\'t Worry Be Happy!'],
                                       ['organization_id', '119'],
                                       ['tags', 'Springville,Sutton,Hartsville/Hartley,Diaperville'],
                                       ['suspended', 'true'],
                                       ['role', 'admin'],
                                       ['organisation_name', 'Multron'],
                                       ['submitted_ticket', 'problem: A Nuisance in Kiribati'],
                                       ['submitted_ticket', 'task: A Nuisance in Saint Lucia'],
                                       ['assigned_ticket', 'problem: A Problem in Russian Federation'],
                                       ['assigned_ticket', 'task: A Problem in Malawi']]

        array_lines = output_lines.last(expected_output_array_lines.size).map{ |line| line.split(/\s/,2) }
        expect(array_lines).to match_array(expected_output_array_lines)
      end
    end
  end
end
