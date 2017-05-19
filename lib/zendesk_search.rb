require 'zendesk_search/version'

module ZendeskSearch
  # Your code goes here...
  def self.new_cli(input: $stdin, output: $stdout)
    CLI.new(input: input, output: output)
  end

  class CLI
    def initialize(input: $stdin, output: $stdout)
      require 'highline'
      @highline = HighLine.new(input, output)
    end

    def run
      require 'json'
      users = JSON.parse(File.read(__dir__ + '/../data/users.json'))
      _search_type = @highline.ask 'Select search type'
      search_term = @highline.ask 'Select search term'
      search_value = @highline.ask 'Select search value'
      matched_user = users.find { |user| user.fetch(search_term).to_s == search_value }
      matched_user.each do |term, value|
        value = value.join(',') if value.respond_to?(:join)
        @highline.say "#{term} : #{value}"
      end

      organizations = JSON.parse(File.read(__dir__ + '/../data/organizations.json'))
      matched_organisation = organizations.find do |organisation|
        organisation.fetch('_id') == matched_user.fetch('organization_id')
      end
      @highline.say "organisation_name : #{matched_organisation.fetch('name')}"

      tickets = JSON.parse(File.read(__dir__ + '/../data/tickets.json'))
      submitted_tickets = tickets.select do |ticket|
        ticket.fetch('submitter_id') == matched_user.fetch('_id')
      end
      submitted_ticket_subjects = submitted_tickets.map { |ticket| ticket.fetch('subject') }
      submitted_ticket_subjects.each do |subject|
        @highline.say "submitted_ticket : #{subject}"
      end
      assigned_tickets = tickets.select do |ticket|
        ticket['assignee_id'] == matched_user.fetch('_id')
      end
      assigned_ticket_subjects = assigned_tickets.map { |ticket| ticket.fetch('subject') }
      assigned_ticket_subjects.each do |subject|
        @highline.say "assigned_ticket : #{subject}"
      end
    end
  end
end
