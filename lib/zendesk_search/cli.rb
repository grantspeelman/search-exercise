class ZendeskSearch::CLI
  def initialize(input: $stdin, output: $stdout)
    require 'highline'
    @cli = HighLine.new(input, output)
  end

  def run
    loop do
      search_choice = choose_search_type
      break if search_choice == :exit
    end
    @cli.say "Thank you for using Zendesk Search"
  end

  def choose_search_type
    answer = @cli.choose do |menu|
      # you can also use constants like :blue
      menu.prompt = "What would you like to search?"
      menu.choice(:users)
      menu.choice(:tickets)
      menu.choice(:organisations)
      menu.choice(:exit)
    end
    answer
  rescue => e
    $stderr << e.message
    :exit
  end
end