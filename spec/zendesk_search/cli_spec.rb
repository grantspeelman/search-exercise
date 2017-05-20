require 'spec_helper'

RSpec.describe ZendeskSearch::CLI do
  let(:user_input) { [] }
  let(:results_displayer) { DummyResultsdisplayer.new }

  class DummyResultsdisplayer
    attr_reader :show_results

    def show(results)
      @show_results = results
    end
  end

  subject do
    ZendeskSearch::CLI.new(user_input: user_input,
                           results_displayer: results_displayer)
  end

  it 'finds users' do
    user_input << %w(users _id 1)
    subject.run
    expect(results_displayer.show_results.size).to eq(1)
    first_result = results_displayer.show_results.first
    expect(first_result)
      .to eq('_id' => 1,
             'url' =>  'http://initech.zendesk.com/api/v2/users/1.json',
             'external_id' => '74341f74-9c79-49d5-9611-87ef9b6eb75f',
             'name' => 'Francisca Rasmussen',
             'alias' => 'Miss Coffey',
             'created_at' => '2016-04-15T05:19:46 -10:00',
             'active' => true,
             'verified' => true,
             'shared' => false,
             'locale' => 'en-AU',
             'timezone' => 'Sri Lanka',
             'last_login_at' => '2013-08-04T01:03:27 -10:00',
             'email' => 'coffeyrasmussen@flotonic.com',
             'phone' => '8335-422-718',
             'signature' => 'Don\'t Worry Be Happy!',
             'organization_id' => 119,
             'tags' => ['Springville', 'Sutton', 'Hartsville/Hartley', 'Diaperville'],
             'suspended' => true,
             'role' => 'admin',
             'organisation_name' => 'Multron',
             'submitted ticket 0' => 'A Nuisance in Kiribati',
             'submitted ticket 1' => 'A Nuisance in Saint Lucia',
             'assigned ticket 0' => 'A Problem in Russian Federation',
             'assigned ticket 1' => 'A Problem in Malawi')
  end

  it 'finds multiple users on organization_id' do
    user_input << %w(users organization_id 104)
    subject.run
    expect(results_displayer.show_results.size).to eq(4)
    ids = results_displayer.show_results.map { |result| result.fetch('_id') }
    expect(ids).to contain_exactly(3, 7, 20, 31)
  end

  it 'finds organizations on id' do
    user_input << %w(organizations _id 101)
    subject.run
    expect(results_displayer.show_results.size).to eq(1)
    first_result = results_displayer.show_results.first
    expect(first_result)
      .to eq('_id' => 101,
             'url' => 'http://initech.zendesk.com/api/v2/organizations/101.json',
             'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d',
             'name' => 'Enthaze',
             'domain_names' => ['kage.com', 'ecratic.com', 'endipin.com', 'zentix.com'],
             'created_at' => '2016-05-21T11:10:28 -10:00',
             'details' => 'MegaCorp',
             'shared_tickets' => false,
             'tags' => %w(Fulton West Rodriguez Farley),
             'user 0' => 'Loraine Pittman',
             'user 1' => 'Francis Bailey',
             'user 2' => 'Haley Farmer',
             'user 3' => 'Herrera Norman')
  end
end
