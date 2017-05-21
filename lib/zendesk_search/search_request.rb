class ZendeskSearch::SearchRequest
  include Comparable

  attr_reader :type
  attr_reader :term
  attr_reader :value

  def initialize(type: 'users',
                 term: '',
                 value: '')
    @type = type.clone.freeze
    @term = term.clone.freeze
    @value = value.clone.freeze
  end

  def <=>(other)
    [type, term, value] <=> [other.type, other.term, other.value]
  end
end
