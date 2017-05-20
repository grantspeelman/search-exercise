require 'spec_helper'

RSpec.describe ZendeskSearch::CLI do
  let(:output) { StringIO.new('', 'w') }
  let(:input) { StringIO.new('', 'r') }
  let(:highline) { HighLine.new(input, output) }
  let(:user_input) { [] }
  subject { ZendeskSearch::CLI.new(highline: highline, user_input: user_input) }

  it 'finds users' do
    user_input << %w(users _id 1)
    subject.run
    output_lines = output.string.lines.map(&:chomp)
    expected_output_array_lines = ['_id : 1',
                                   'url : http://initech.zendesk.com/api/v2/users/1.json',
                                   'external_id : 74341f74-9c79-49d5-9611-87ef9b6eb75f',
                                   'name : Francisca Rasmussen',
                                   'alias : Miss Coffey',
                                   'created_at : 2016-04-15T05:19:46 -10:00',
                                   'active : true',
                                   'verified : true',
                                   'shared : false',
                                   'locale : en-AU',
                                   'timezone : Sri Lanka',
                                   'last_login_at : 2013-08-04T01:03:27 -10:00',
                                   'email : coffeyrasmussen@flotonic.com',
                                   'phone : 8335-422-718',
                                   'signature : Don\'t Worry Be Happy!',
                                   'organization_id : 119',
                                   'tags : Springville,Sutton,Hartsville/Hartley,Diaperville',
                                   'suspended : true',
                                   'role : admin',
                                   'organisation_name : Multron',
                                   'submitted ticket : A Nuisance in Kiribati',
                                   'submitted ticket : A Nuisance in Saint Lucia',
                                   'assigned ticket : A Problem in Russian Federation',
                                   'assigned ticket : A Problem in Malawi']

    array_lines = output_lines.last(expected_output_array_lines.size)
    expect(array_lines).to match_array(expected_output_array_lines)
    expect(array_lines).to eq(expected_output_array_lines)
  end

  it 'finds multiple users on organization_id' do
    user_input << %w(users organization_id 104)
    subject.run
    output_lines = output.string.lines.map(&:chomp)
    expect(output_lines).to include('_id : 3')
    expect(output_lines).to include('_id : 7')
    expect(output_lines).to include('_id : 20')
    expect(output_lines).to include('_id : 31')
  end

  it 'finds organizations on id' do
    user_input << %w(organizations _id 101)
    subject.run
    output_lines = output.string.lines.map(&:chomp)
    expected_output_array_lines = ['_id : 101',
                                   'url : http://initech.zendesk.com/api/v2/organizations/101.json',
                                   'external_id : 9270ed79-35eb-4a38-a46f-35725197ea8d',
                                   'name : Enthaze',
                                   'domain_names : kage.com,ecratic.com,endipin.com,zentix.com',
                                   'created_at : 2016-05-21T11:10:28 -10:00',
                                   'details : MegaCorp',
                                   'shared_tickets : false',
                                   'tags : Fulton,West,Rodriguez,Farley',
                                   'user : Loraine Pittman',
                                   'user : Francis Bailey',
                                   'user : Haley Farmer',
                                   'user : Herrera Norman']

    array_lines = output_lines.last(expected_output_array_lines.size)
    expect(array_lines).to match_array(expected_output_array_lines)
    expect(array_lines).to eq(expected_output_array_lines)
  end
end
