class ZendeskSearch::ResultsDisplayer
  # @param [Highline] highline
  def initialize(highline = HighLine.new)
    @highline = highline
    @line_formatters_hash = Hash.new(SimpleLineFormatter.new)
    @line_formatters_hash['StringArrayLineFormatter'] = StringArrayLineFormatter.new
    @line_formatters_hash['ZendeskSearch::AssociationDescriptionArrayLineFormatter'] =
      AssociationLineFormatter.new
  end

  class SimpleLineFormatter
    def format(term, value)
      "#{term} : #{value}\n"
    end
  end

  class StringArrayLineFormatter
    def format(term, value)
      "#{term} : #{value.join(', ')}\n"
    end
  end

  class AssociationLineFormatter
    def format(term, value)
      value.each_with_index.map do |associate, i|
        "#{term.name} #{i} : #{associate['name'] || associate['subject']}\n"
      end.join
    end
  end

  # @param [Array<ZendeskSearch::SearchResult>] results
  def show_results(results)
    if results.empty?
      @highline.say "No results found\n"
    else
      array_of_text_results = results.map do |result|
        result.attributes.map do |term, value|
          line_formatter = @line_formatters_hash["#{term.class}#{value.class}LineFormatter"]
          line_formatter.format(term, value)
        end.join
      end
      @highline.say array_of_text_results.join("----------------------------\n")
    end
  end
end
