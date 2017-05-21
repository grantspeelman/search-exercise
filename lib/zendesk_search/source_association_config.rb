require 'yaml'

class ZendeskSearch::SourceAssociationConfig
  def initialize(source_directory = 'data')
    @config_data = YAML.load_file(source_directory + '/source_association_config.yml')
  end

  # @param [String] source_name
  # @return [Array<ZendeskSearch::AssociationDescription>]
  def descriptions_for(source_name)
    (@config_data[source_name] || []).map do |config|
      ZendeskSearch::AssociationDescription.new(config)
    end
  end
end
