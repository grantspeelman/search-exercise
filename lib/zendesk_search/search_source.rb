class ZendeskSearch::SearchSource
  def initialize(source_name, source_directory: 'data')
    @source_file = "#{source_directory}/#{source_name}.json"
  end

  def all
    file_contents = File.read(@source_file)
    JSON.parse(file_contents)
  end

  def search(term: '', value: '')
    all.select do |row|
      is_row_match?(row, term, value)
    end
  end

  def find_first(term: '', value: '')
    all.find do |row|
      is_row_match?(row, term, value)
    end
  end

  private

  def is_row_match?(row, term, value)
    row_term = row[term]
    if row_term.kind_of?(Array)
      row_term.include?(value)
    else
      row_term.to_s == value.to_s
    end
  end
end
