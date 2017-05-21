class ZendeskSearch::CLI
  attr_reader :tickets
  attr_reader :organizations
  attr_reader :users

  def initialize(user_input: ZendeskSearch::UserInput.new,
                 results_displayer: ZendeskSearch::ResultsDisplayer.new)

    @user_input = user_input
    @tickets = ZendeskSearch::SearchSource.new('tickets')
    @organizations = ZendeskSearch::SearchSource.new('organizations')
    @users = ZendeskSearch::SearchSource.new('users')
    @results_displayer = results_displayer
  end

  def run
    @user_input.each do |search_request|
      if search_request.type == 'tickets'
        results = tickets.search(term: search_request.term, value: search_request.value)
        results.each do |result|
          matched_organisation = organizations.find_first(term: '_id',
                                                          value:  result.fetch('organization_id'))
          result['organisation name'] = matched_organisation.fetch('name')

          matched_submitter = users.find_first(term: '_id',
                                               value:  result.fetch('submitter_id'))
          result['submitter name'] = matched_submitter.fetch('name')

          matched_assignee = users.find_first(term: '_id',
                                              value:  result.fetch('assignee_id'))
          result['assignee name'] = matched_assignee.fetch('name')
        end
      elsif search_request.type == 'organizations'
        results = organizations.search(term: search_request.term, value: search_request.value)
        results.each do |result|
          matched_users = users.search(term: 'organization_id', value: result.fetch('_id'))
          matched_users.each_with_index do |user, index|
            result["user #{index}"] = user.fetch('name').to_s
          end
        end
      elsif search_request.type == 'users'
        results = users.search(term: search_request.term, value: search_request.value)
        results.each do |result|
          matched_organisation = organizations.find_first(term: '_id',
                                                          value:  result.fetch('organization_id'))
          result['organisation_name'] = matched_organisation.fetch('name')

          user_id = result.fetch('_id')

          ticket_association_term = 'submitter_id'
          submitted_tickets = tickets.search(term: ticket_association_term, value: user_id)
          submitted_ticket_subjects = submitted_tickets.map { |ticket| ticket.fetch('subject') }

          ticket_association_type = 'submitted'
          submitted_ticket_subjects.each_with_index do |subject, index|
            result["#{ticket_association_type} ticket #{index}"] = subject
          end

          ticket_association_term = 'assignee_id'
          assigned_tickets = tickets.search(term: ticket_association_term, value: user_id)
          assigned_ticket_subjects = assigned_tickets.map { |ticket| ticket.fetch('subject') }

          ticket_association_type = 'assigned'
          assigned_ticket_subjects.each_with_index do |subject, index|
            result["#{ticket_association_type} ticket #{index}"] = subject
          end
        end
      end

      @results_displayer.show(results)
    end
  end
end
