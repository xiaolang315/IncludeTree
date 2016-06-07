require "YAML"

class IncludeTreeConfig
  attr_reader:include_search_path
  attr_reader:cpp_output_path
  attr_reader:cpp_search_path
  def  initialize()
    yaml = YAML.load(File.open("config.yaml"))
    @cpp_output_path = yaml["cpp_output_path"]
    @cpp_search_path = yaml["cpp_search_path"]
    @include_search_path = getIncludePath(yaml["cmake_path"])
  end
  private
  def getIncludePath(cmakefile)
    orign = IO.readlines(cmakefile + "CMakeLists.txt").join(" ")
    includes = orign[/(INCLUDE_DIRECTORIES\()([^)]*)/,2].delete!("\"")
    includes.gsub(/\$\{CMAKE_CURRENT_SOURCE_DIR\}/,"#{cmakefile.chop}").split
  end
end
