require "find"
require_relative "config.rb"
require_relative "IncludeObj.rb" 

def readInclude(file)
  return IO.readlines(file).delete_if do |line| 
    not (line.valid_encoding? and line =~ /^#include/)
  end
end

def getShortName(line)
  return line.split('/').pop
end

def getRealName(line)
  line.slice!("#include")
  line.chomp!
  line.rstrip!
  line.strip!
  line.delete!("\"<>")
end

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
    allList = {"use"=>{},"useless"=>{}, "notfound"=>[]}
    lines.map{ |line| getRealName(line)}
      .each do |name|
      if(@list.has_key?name )
        allList[has(@list[name], allList["use"])? "use":"useless"][name] = @list[name]
      else
        allList["notfound"] << name
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

class CppInfo
  attr_reader:name
  attr_reader:size
  attr_reader:path
  attr_reader:includes
  attr_reader:size_includes
  attr_reader:sum

  def  initialize(file, list)
    @name = getShortName(file)
    @path = file
    @size = File.size(@path)
    @sum = 0
    @size_includes = []
    paserInclude(list)
  end

  def output(dst)
    all = @includes
    dst.puts("===============#{@name} has useful include #{all["use"].size} ; and useless #{all["useless"].size}.")
    all["useless"].each_value do |line| 
      dst.puts("#{line.name} is include in other")
    end
    dst.puts(" include sum size is #{@sum}, cpp size is #{@size}")
    @size_includes.each do |line| 
      dst.puts("#{line.name}  size is #{line.size}")
    end
  end

private
  def paserInclude(list)
    @includes = list.getRelLines(readInclude(@path))
    @includes ["use"].each_value do |line| 
      line.getInclude(@size_includes )
    end
    @size_includes .uniq!
    @size_includes .each do |line| 
      @sum += line.size
    end
  end

end

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
