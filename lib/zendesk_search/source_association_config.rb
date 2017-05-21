require 'yaml'

class ZendeskSearch::SourceAssociationConfig
  def initialize
    @config_data = YAML.load_file(__dir__ + '/source_association_config.yml')
  end

  # @param [String] source_name
  # @return [Array<Hash>]
  def for(source_name)
    @config_data[source_name] || []
  end
end
