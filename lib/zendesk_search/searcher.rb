class ZendeskSearch::Searcher
  def initialize(association_config: ZendeskSearch::SourceAssociationConfig.new)
    @association_config = association_config
  end

  # @param [ZendeskSearch::SearchRequest] request
  # @return [Array<Hash>]
  def search(request)
    # do initial search
    source = ZendeskSearch::SearchSource.new(request.type)
    results = source.search(term: request.term, value: request.value).map do |raw_result|
      ZendeskSearch::SearchResult.new(raw_result)
    end

    # define mappings
    associated_mappings = @association_config.for(request.type)

    # do mapping
    results.each do |result|
      associated_mappings.each do |associated_mapping|
        associated_source = ZendeskSearch::SearchSource.new(associated_mapping.fetch(:associate_source))
        associated_results = associated_source.search(term: associated_mapping.fetch(:associate_term),
                                                      value:  result.fetch(associated_mapping.fetch(:term)))
        associated_results.each_with_index do |associated_result, index|
          result_key = "#{associated_mapping.fetch(:name)} #{index} #{associated_mapping.fetch(:display)}"
          result[result_key] = associated_result.fetch(associated_mapping.fetch(:display))
        end
      end
    end
  end
end
