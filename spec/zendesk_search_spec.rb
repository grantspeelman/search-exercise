require 'spec_helper'

RSpec.describe ZendeskSearch do
  it 'has a version number' do
    expect(ZendeskSearch::VERSION).not_to be nil
  end

  let(:output) { StringIO.new('', 'w') }
  let(:input) { StringIO.new('', 'r') }
  subject { ZendeskSearch.new_cli(input: input, output: output) }

  def enters(*texts)
    input.string = texts.join("\n")
    input.rewind
  end

  describe 'search for users' do
    it 'finds user on id' do
      enters 'users', '_id', '1', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
      output_lines.pop(5) # remove Select search type text
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
                                     'tags : Springville, Sutton, Hartsville/Hartley, Diaperville',
                                     'suspended : true',
                                     'role : admin',
                                     'organization 0 name : Multron',
                                     'submitted ticket 0 subject : A Nuisance in Kiribati',
                                     'submitted ticket 1 subject : A Nuisance in Saint Lucia',
                                     'assigned ticket 0 subject : A Problem in Russian Federation',
                                     'assigned ticket 1 subject : A Problem in Malawi']

      array_lines = output_lines.last(expected_output_array_lines.size)
      expect(array_lines).to match_array(expected_output_array_lines)
      expect(array_lines).to eq(expected_output_array_lines)
    end

    it 'finds users on name' do
      enters 'users', 'name', 'Cross Barlow', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
      output_lines.pop(5) # remove Select search type text
      expected_output_array_lines = ['_id : 2',
                                     'url : http://initech.zendesk.com/api/v2/users/2.json',
                                     'external_id : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2',
                                     'name : Cross Barlow',
                                     'alias : Miss Joni',
                                     'created_at : 2016-06-23T10:31:39 -10:00',
                                     'active : true',
                                     'verified : true',
                                     'shared : false',
                                     'locale : zh-CN',
                                     'timezone : Armenia',
                                     'last_login_at : 2012-04-12T04:03:28 -10:00',
                                     'email : jonibarlow@flotonic.com',
                                     'phone : 9575-552-585',
                                     'signature : Don\'t Worry Be Happy!',
                                     'organization_id : 106',
                                     'tags : Foxworth, Woodlands, Herlong, Henrietta',
                                     'suspended : false',
                                     'role : admin',
                                     'organization 0 name : Qualitern',
                                     'assigned ticket 0 subject : A Catastrophe in Bermuda',
                                     'assigned ticket 1 subject : A Problem in Svalbard and Jan Mayen Islands']

      array_lines = output_lines.last(expected_output_array_lines.size)
      expect(array_lines).to match_array(expected_output_array_lines)
      expect(array_lines).to eq(expected_output_array_lines)
    end

    it 'finds multiple users on organization_id' do
      enters 'users', 'organization_id', '104', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
      output_lines.pop(5) # remove Select search type text
      expect(output_lines).to include('_id : 3')
      expect(output_lines).to include('_id : 7')
      expect(output_lines).to include('_id : 20')
      expect(output_lines).to include('_id : 31')
    end
  end

  describe 'search for organizations' do
    it 'finds organization on id' do
      enters 'organizations', '_id', '101', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
      output_lines.pop(5) # remove Select search type text
      expected_output_array_lines = ['_id : 101',
                                     'url : http://initech.zendesk.com/api/v2/organizations/101.json',
                                     'external_id : 9270ed79-35eb-4a38-a46f-35725197ea8d',
                                     'name : Enthaze',
                                     'domain_names : kage.com, ecratic.com, endipin.com, zentix.com',
                                     'created_at : 2016-05-21T11:10:28 -10:00',
                                     'details : MegaCorp',
                                     'shared_tickets : false',
                                     'tags : Fulton, West, Rodriguez, Farley',
                                     'user 0 name : Loraine Pittman',
                                     'user 1 name : Francis Bailey',
                                     'user 2 name : Haley Farmer',
                                     'user 3 name : Herrera Norman']

      array_lines = output_lines.last(expected_output_array_lines.size)
      expect(array_lines).to match_array(expected_output_array_lines)
      expect(array_lines).to eq(expected_output_array_lines)
    end
  end
end
