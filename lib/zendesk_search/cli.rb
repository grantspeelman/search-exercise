class ZendeskSearch::CLI
  def initialize(user_input: ZendeskSearch::UserInput.new,
                 results_displayer: ZendeskSearch::ResultsDisplayer.new,
                 searcher: ZendeskSearch::Searcher.new)
    @searcher = searcher
    @results_displayer = results_displayer
    @user_input = user_input
    @user_input.source_choices = @searcher.search_sources
  end

  def run
    @user_input.each do |search_request|
      results = @searcher.search(search_request)
      @results_displayer.show_results(results)
    end
  end
end
