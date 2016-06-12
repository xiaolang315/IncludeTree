require_relative "IncludeList.rb" 

class PaserInfo
  attr_reader:name
  attr_reader:size
  attr_reader:path
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
    useless =  @includes.select{|line| not line.used}
    dst.puts("===============#{@name} has useful include #{@includes.size - useless.size} ; and useless top include #{useless.size}.")
    dst.puts(" include sum size is #{@sum}, cpp size is #{@size}")
    @includes.each do |line| 
      line.dump(dst) 
    end
  end

  private
  def paserInclude(list)
    @includes = list.getRelLines(@path)

    list = []
    @includes.each do |line| 
      line.markuse(list)
    end

    @includes.each do |line| 
      @sum += line.getSize
    end
  end
end
