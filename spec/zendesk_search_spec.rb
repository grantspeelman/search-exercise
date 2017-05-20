require 'spec_helper'

RSpec.describe ZendeskSearch do
  it 'has a version number' do
    expect(ZendeskSearch::VERSION).not_to be nil
  end

  describe 'search for users' do
    let(:output) { StringIO.new('', 'w') }
    let(:input) { StringIO.new('', 'r') }
    subject { ZendeskSearch.new_cli(input: input, output: output) }

    def enters(*texts)
      input.string = texts.join("\n")
      input.rewind
    end

    it 'finds user on id' do
      enters 'users', '_id', '1', 'exit'
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
                                     'submitted_ticket : A Nuisance in Kiribati',
                                     'submitted_ticket : A Nuisance in Saint Lucia',
                                     'assigned_ticket : A Problem in Russian Federation',
                                     'assigned_ticket : A Problem in Malawi']

      array_lines = output_lines.last(expected_output_array_lines.size)
      expect(array_lines).to match_array(expected_output_array_lines)
      expect(array_lines).to eq(expected_output_array_lines)
    end

    it 'finds users on name' do
      enters 'users', 'name', 'Cross Barlow', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
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
                                     'tags : Foxworth,Woodlands,Herlong,Henrietta',
                                     'suspended : false',
                                     'role : admin',
                                     'organisation_name : Qualitern',
                                     'assigned_ticket : A Catastrophe in Bermuda',
                                     'assigned_ticket : A Problem in Svalbard and Jan Mayen Islands']

      array_lines = output_lines.last(expected_output_array_lines.size)
      expect(array_lines).to match_array(expected_output_array_lines)
      expect(array_lines).to eq(expected_output_array_lines)
    end

    it 'finds multiple users on organization_id' do
      enters 'users', 'organization_id', '104', 'exit'
      subject.run
      output_lines = output.string.lines.map(&:chomp)
      expect(output_lines).to include('_id : 3')
      expect(output_lines).to include('_id : 7')
      expect(output_lines).to include('_id : 20')
      expect(output_lines).to include('_id : 31')
    end
  end
end
