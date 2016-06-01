class IncludeObj
  attr_reader:name
  attr_reader:size
  attr_reader:path
  def  initialize(file, path)
    @include = []
    tmp = ""
    tmp<< file
    tmp.slice!(path)
    @name = tmp[1..tmp.length]
    @path= file
    @size = getSize() 
  end

  def has(include)
    @include.include?(include)
  end

  def getInclude(list)
    list.concat(@include)
  end

  def dump()
    puts "=============#{@name}================================"
    puts "has #{@include.size} include "
    puts "size is #{@size} "
    puts "path is #{@path} "
  end

  def add(includeObj)
    @include<< includeObj
  end

  private
  def getSize()
    list = []
    size = File.size(@path)
    @include.each do |file| 
      list.concat(getInclude(list))
    end
    list.uniq!
    list.each do |file| 
      size += file.size
    end
    return size 
  end
end
