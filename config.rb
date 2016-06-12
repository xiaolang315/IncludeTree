require "YAML"

class Matcher
  def  initialize(str)
    @list = str.split
    @list = @list.map{ |var| var.delete!('.') }
    p @list
  end

  def include(file)
    return @list.include?(file.split('.').pop)
  end
end

class IncludeTreeConfig
  attr_reader:include_search_path
  attr_reader:output_path
  attr_reader:search_path
  def  initialize()
    @yaml = YAML.load(File.open("config.yaml"))
    @output_path = @yaml["output_path"]
    @search_path = @yaml["search_path"]
    @include_search_path = getIncludePath(@yaml["cmake_path"])
  end

  def getMatcher
    return Matcher.new(@yaml["file_type"])
  end

  private
  def getIncludePath(cmakefile)
    orign = IO.readlines(cmakefile + "CMakeLists.txt").join(" ")
    includes = orign[/(INCLUDE_DIRECTORIES\()([^)]*)/,2].delete!("\"")
    includes.gsub(/\$\{CMAKE_CURRENT_SOURCE_DIR\}/,"#{cmakefile.chop}").split
  end
end
