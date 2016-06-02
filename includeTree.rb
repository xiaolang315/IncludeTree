require "find"
require_relative "config.rb"
require_relative "IncludeObj.rb" 
require_relative "IncludeList.rb" 
require_relative "CppInfo.rb" 
require_relative "Utils.rb" 

class IncludeTree
  def  initialize(config)
    @config = config
    @list = IncludeList.new(config.include_search_path)
  end

  def paserCpps()
    cppOutList = []
    cpplist = Find.find(@config.cpp_search_path).select{ |file| file =~ /\.cpp$/ }
    cpplist.each do |file|
      cppOutList << listAllInclude(file)
    end
    output(cppOutList)
  end

  private
  def output(outList)
    dst = File.new(@config.cpp_output_path, "w+")
    list = outList.sort do |a, b| 
      a.sum <=> b.sum
    end
    list.each {|cpp| cpp.output(dst)}
    dst.close
  end

  def listAllInclude(file)
    CppInfo.new(file, @list)
  end

end

tree = IncludeTree.new(IncludeTreeConfig.new)
tree.paserCpps()
