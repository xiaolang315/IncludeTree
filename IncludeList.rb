require_relative "IncludeObj.rb" 
require_relative "CppInclude.rb" 
require "find"

class IncludeList
  def  initialize(searchPath)
    @list = {}
    @searchPath = searchPath
    @searchPath.each do |path| 
      buildList(path)
    end 
    @list.each_value do |file| 
      listAllInclude(file)
    end
  end

  def dump()
    @list.each_value do |file| 
      file.dump
    end
  end

  def buildList(searchPath)
    files = Find.find(searchPath).select{ |file| (file =~ /(\.h)|(\.tcc)$/ ) }
    files.each do |file|
      obj = IncludeObj.new(file, searchPath);
      @list[obj.name] = obj
    end
  end

  def getInclude(shortName)
    return @list[shortName]
  end

  def has(include, list)
    return list.values.select{ |line| line.has(include) }.empty?
  end

  def getRelLines(lines)
    allList = []
    lines.map{ |line| getRealName(line)}
      .each do |name|
      if(@list.has_key?name )
        allList << CppInclude.new(false, @list[name])
      else
        puts "#{name} not found in searchPath"
      end
    end
    return allList;
  end

  def listAllInclude(file)
    readInclude(file.path).map{ |line| getRealName(line)}
      .select{ |name| (@list.has_key?(name) and file != @list[name])}
      .each{ |name| file.add(@list[name])}
  end
end
