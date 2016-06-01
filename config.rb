require "YAML"

class IncludeTreeConfig
  attr_reader:include_search_path
  attr_reader:include_output_path
  attr_reader:cpp_output_path
  attr_reader:cpp_search_path
  def  initialize()
    yaml = YAML.load(File.open("config.yaml"))
    @include_search_path = yaml["include_search_path"].split
    @cpp_output_path = yaml["cpp_output_path"]
    @cpp_search_path = yaml["cpp_search_path"]
    @include_output_path = yaml["include_output_path"]
  end
end
