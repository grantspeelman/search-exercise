class ZendeskSearch::Searcher
  # @param [ZendeskSearch::SearchRequest] request
  # @return [Array<Hash>]
  def search(request)
    # do initial search
    source = ZendeskSearch::SearchSource.new(request.type)
    results = source.search(term: request.term, value: request.value).map do |raw_result|
      ZendeskSearch::SearchResult.new(raw_result)
    end

    # define mappings
    if request.type == 'tickets'
      associated_mappings = [
        { name: 'organization',
          type: 'organizations',
          term: '_id',
          match_on: 'organization_id',
          display: 'name' },
        {
          name: 'submitter',
          type: 'users',
          term: '_id',
          match_on: 'submitter_id',
          display: 'name'
        },
        {
          name: 'assignee',
          type: 'users',
          term: '_id',
          match_on: 'assignee_id',
          display: 'name'
        }
      ]
    elsif request.type == 'organizations'
      associated_mappings = [
        { name: 'user',
          type: 'users',
          term: 'organization_id',
          match_on: '_id',
          display: 'name' }
      ]
    elsif request.type == 'users'
      associated_mappings = [
        { name: 'organization',
          type: 'organizations',
          term: '_id',
          match_on: 'organization_id',
          display: 'name' },
        { name: 'submitted ticket',
          type: 'tickets',
          term: 'submitter_id',
          match_on: '_id',
          display: 'subject' },
        { name: 'assigned ticket',
          type: 'tickets',
          term: 'assignee_id',
          match_on: '_id',
          display: 'subject' }
      ]
    end

    # do mapping
    results.each do |result|
      associated_mappings.each do |associated_mapping|
        associated_source = ZendeskSearch::SearchSource.new(associated_mapping.fetch(:type))
        associated_results = associated_source.search(term: associated_mapping.fetch(:term),
                                                      value:  result.fetch(associated_mapping.fetch(:match_on)))
        associated_results.each_with_index do |associated_result, index|
          result_key = "#{associated_mapping.fetch(:name)} #{index} #{associated_mapping.fetch(:display)}"
          result[result_key] = associated_result.fetch(associated_mapping.fetch(:display))
        end
      end
    end
  end
end
