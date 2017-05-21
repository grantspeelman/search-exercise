class ZendeskSearch::ResultsDisplayer
  # @param [Highline] highline
  def initialize(highline = HighLine.new)
    @highline = highline
  end

  # @param [Array<Hash>] results
  def show(results)
    array_of_text_results = results.map do |result|
      result.map do |term, value|
        if value.is_a?(Array)
          "#{term} : #{value.join(', ')}\n"
        else
          "#{term} : #{value}\n"
        end
      end.join
    end
    @highline.say array_of_text_results.join("----------\n")
  end
end