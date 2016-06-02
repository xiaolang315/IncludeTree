class IncludeObj
  attr_reader:name
  attr_reader:size
  attr_reader:base_size
  attr_reader:path
  attr_reader:includes
  def  initialize(file, path)
    @includes = []
    tmp = ""
    tmp<< file
    tmp.slice!(path)
    @name = tmp[1..tmp.length]
    @path= file
    @base_size = File.size(@path);
    @size = getSize() 
  end

  def has(include)
    @includes.include?(include)
  end

  def dump()
    puts "=============#{@name}================================"
    puts "has #{@includes.size} include "
    puts "size is #{@size} "
    puts "path is #{@path} "
  end

  def add(includeObj)
    @includes << includeObj
  end

  private
  def getSize()
    list = []
    size = @base_size
    @includes.each do |file| 
      list.concat(getInclude(list))
    end
    list.uniq!
    list.each do |file| 
      size += file.size
    end
    return size 
  end
end
