class ZendeskSearch::CLI
  attr_reader :tickets
  attr_reader :organizations
  attr_reader :users

  def initialize(user_input: ZendeskSearch::UserInput.new,
                 results_displayer: ZendeskSearch::ResultsDisplayer.new,
                 searcher: ZendeskSearch::Searcher.new)

    @user_input = user_input
    @searcher = searcher
    @results_displayer = results_displayer
  end

  def run
    @user_input.each do |search_request|
      results = @searcher.search(search_request)
      @results_displayer.show(results)
    end
  end
end
