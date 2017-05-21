class ZendeskSearch::AssociationDescription
  attr_reader :name, :associate_source, :associate_term, :term, :display

  def initialize(association_config)
    @name = association_config.fetch(:name).clone.freeze
    @associate_source = association_config.fetch(:associate_source).clone.freeze
    @associate_term = association_config.fetch(:associate_term).clone.freeze
    @term = association_config.fetch(:term).clone.freeze
  end

  def to_h
    { name: name,
      associate_source: associate_source,
      associate_term: associate_term,
      term: term }
  end
end
