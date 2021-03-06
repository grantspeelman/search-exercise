class ZendeskSearch::SearchResult
  attr_reader :attributes

  def initialize(raw_hash)
    @attributes = raw_hash
  end

  def fetch(field)
    @attributes.fetch(field)
  end

  def []=(key, value)
    @attributes[key] = value
  end
end
