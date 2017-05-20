class ZendeskSearch::SearchSource
  include Enumerable

  def initialize(source_name, source_directory: 'data')
    @source_file = "#{source_directory}/#{source_name}.json"
  end

  def each
    file_contents = File.read(@source_file)
    parse_contents = JSON.parse(file_contents)
    parse_contents.each do |row|
      yield row
    end
  end
end
