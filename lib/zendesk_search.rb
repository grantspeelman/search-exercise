require 'json'
require 'highline'
require 'zendesk_search/version'

module ZendeskSearch
  require 'zendesk_search/search_source'
  require 'zendesk_search/user_input'
  require 'zendesk_search/cli'
  # Your code goes here...
  def self.new_cli(input: $stdin, output: $stdout)
    highline = HighLine.new(input, output)
    user_input = UserInput.new(highline)
    CLI.new(highline: highline, user_input: user_input)
  end
end
