class ZendeskSearch::Searcher
  def initialize(source_directory: 'data',
                 association_config_class: ZendeskSearch::SourceAssociationConfig)
    @source_directory = source_directory
    @association_config = association_config_class.new(source_directory)
  end

  # @param [ZendeskSearch::SearchRequest] request
  # @return [Array<Hash>]
  def search(request)
    # do initial search
    source = ZendeskSearch::SearchSource.new(request.type, @source_directory)
    results = source.search(term: request.term, value: request.value).map do |raw_result|
      ZendeskSearch::SearchResult.new(raw_result)
    end

    # define mappings
    association_descs = @association_config.descriptions_for(request.type)

    # do mapping
    results.each do |result|
      associate(association_descs, result)
    end
  end

  def search_sources
    Dir["#{@source_directory}/*.json"].map do |filename|
      filename.gsub("#{@source_directory}/", '').gsub('.json', '')
    end
  end

  private

  def associate(association_descs, result)
    association_descs.each do |association_desc|
      associated_source = ZendeskSearch::SearchSource.new(association_desc.associate_source, @source_directory)
      associated_results = associated_source.search(term: association_desc.associate_term,
                                                    value: result.attributes[association_desc.term])

      result[association_desc] = associated_results
    end
  end
end
