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

  def search(term: '', value: '')
    select do |row|
      row_term = row[term]
      if row_term.kind_of?(Array)
        row_term.include?(value)
      else
        row_term.to_s == value.to_s
      end
    end
  end
end
