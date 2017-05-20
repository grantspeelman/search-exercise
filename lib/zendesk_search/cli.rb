class ZendeskSearch::CLI
  attr_reader :tickets
  attr_reader :organizations
  attr_reader :users

  def initialize(highline: HighLine.new,
                 user_input: UserInput.new)

    @highline = highline
    @user_input = user_input
    @tickets = ZendeskSearch::SearchSource.new('tickets')
    @organizations = ZendeskSearch::SearchSource.new('organizations')
    @users = ZendeskSearch::SearchSource.new('users')
  end

  def run
    @user_input.each do |search_type, search_term, search_value|
      if search_type == 'organizations'
        search_results = organizations.search(term: search_term, value: search_value)
        search_results.each do |result|
          result.each do |term, value|
            value = value.join(',') if value.respond_to?(:join)
            @highline.say "#{term} : #{value}"
          end

          matched_users = users.search(term: 'organization_id', value: result.fetch('_id'))
          matched_users.each do |user|
            @highline.say "user : #{user.fetch('name')}"
          end
        end
      else
        matched_users = users.search(term: search_term, value: search_value)
        matched_users.each do |matched_user|
          matched_user.each do |term, value|
            value = value.join(',') if value.respond_to?(:join)
            @highline.say "#{term} : #{value}"
          end

          matched_organisation = organizations.find_first(term: '_id',
                                                          value:  matched_user.fetch('organization_id'))
          @highline.say "organisation_name : #{matched_organisation.fetch('name')}"

          user_id = matched_user.fetch('_id')

          ticket_association_term = 'submitter_id'
          submitted_tickets = tickets.search(term: ticket_association_term, value: user_id)
          submitted_ticket_subjects = submitted_tickets.map { |ticket| ticket.fetch('subject') }

          ticket_association_type = 'submitted'
          submitted_ticket_subjects.each do |subject|
            @highline.say "#{ticket_association_type} ticket : #{subject}"
          end

          ticket_association_term = 'assignee_id'
          assigned_tickets = tickets.search(term: ticket_association_term, value: user_id)
          assigned_ticket_subjects = assigned_tickets.map { |ticket| ticket.fetch('subject') }

          ticket_association_type = 'assigned'
          assigned_ticket_subjects.each do |subject|
            @highline.say "#{ticket_association_type} ticket : #{subject}"
          end
        end

      end
    end
  end
end
