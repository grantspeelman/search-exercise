require 'json'
require 'zendesk_search/version'

module ZendeskSearch
  require 'zendesk_search/search_source'
  # Your code goes here...
  def self.new_cli(input: $stdin, output: $stdout)
    CLI.new(input: input, output: output)
  end

  class CLI
    attr_reader :tickets
    attr_reader :organizations
    attr_reader :users

    def initialize(input: $stdin, output: $stdout)
      require 'highline'
      @highline = HighLine.new(input, output)
      @tickets = SearchSource.new('tickets')
      @organizations = SearchSource.new('organizations')
      @users = SearchSource.new('users')
    end

    def run
      _search_type = @highline.ask 'Select search type'
      search_term = @highline.ask 'Select search term'
      search_value = @highline.ask 'Select search value'
      matched_users = users.search(term: search_term, value: search_value)
      matched_users.each do |matched_user|
        matched_user.each do |term, value|
          value = value.join(',') if value.respond_to?(:join)
          @highline.say "#{term} : #{value}"
        end

        matched_organisation = organizations.find do |organisation|
          organisation.fetch('_id') == matched_user.fetch('organization_id')
        end
        @highline.say "organisation_name : #{matched_organisation.fetch('name')}"

        user_id = matched_user.fetch('_id')
        submitted_tickets = tickets.search(term: 'submitter_id', value: user_id)
        submitted_ticket_subjects = submitted_tickets.map { |ticket| ticket.fetch('subject') }
        submitted_ticket_subjects.each do |subject|
          @highline.say "submitted_ticket : #{subject}"
        end
        assigned_tickets = tickets.search(term: 'assignee_id', value: user_id)
        assigned_ticket_subjects = assigned_tickets.map { |ticket| ticket.fetch('subject') }
        assigned_ticket_subjects.each do |subject|
          @highline.say "assigned_ticket : #{subject}"
        end
      end
    end
  end
end
