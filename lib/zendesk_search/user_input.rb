class ZendeskSearch::UserInput
  # @param [Highline] highline
  def initialize(highline = HighLine.new)
    @highline = highline
  end

  def each
    loop do
      search_type = select_search_type
      break if search_type == 'exit'
      search_term = @highline.ask 'Select search term'
      break if search_term == 'exit'
      search_value = @highline.ask 'Select search value'
      break if search_value == 'exit'
      yield [search_type, search_term, search_value]
    end
  end

  private

  def select_search_type
    @highline.choose do |menu|
      menu.prompt = 'Select search type'
      menu.choices('users', 'organizations', 'tickets', 'exit')
    end
  end
end
