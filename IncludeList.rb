require_relative "IncludeObj.rb" 
require_relative "UsedInclude.rb" 
require "find"

class IncludeList
  def  initialize(searchPath)
    @list = {}
    @searchPath = searchPath
    @searchPath.each { |path| buildList(path) }
    @list.each_value { |file| listAllInclude(file) }
  end

  def dump()
    @list.each_value do |file| 
      file.dump
    end
  end

  def getRelLines(path)
    lines = readInclude(path)
    allList = []
    lines.map{ |line| getRealName(line)}
      .each do |name|
      if(@list.has_key?name )
        allList << UsedInclude.new(false, @list[name])
      else
        #puts "#{name} not found in searchPath, in #{path} "
      end
    end
    return allList;
  end

  private
  def buildList(searchPath)
    return unless Dir.exist? searchPath
    files = Find.find(searchPath).select{ |file| (file =~ /(\.h)|(\.tcc)$/ ) }
    files.each do |file|
      obj = IncludeObj.new(file, searchPath);
      @list[obj.name] = obj
    end
  end

  def listAllInclude(file)
    readInclude(file.path).map{ |line| getRealName(line)}
      .select{ |name| (@list.has_key?(name) and file != @list[name])}
      .each{ |name| file.add(@list[name])}
  end
end
