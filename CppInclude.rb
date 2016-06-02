require_relative "IncludeObj.rb" 

class CppInclude
  attr_reader:used
  attr_reader:include
  attr_accessor:includes
  def initialize(used, include)
    @used = used
    @include = include
    @includes  = []
  end

  def markuse(list)
    @include.includes.each do |include| 
      if(not list.include?(include))
        list << include
        info = CppInclude.new(true, include)
        info.markuse(list)
        @used = true
        @includes << info
      else
        @includes << CppInclude.new(false, include)
      end
    end
  end

  def dump(dst, offset = "")
    str = "#{offset} #{include.name}"
    if(@used)
      str << " size is #{getSize}"
      if(not @includes.empty?)
        str << " has follow include"
      end
    else
      str << " used before"
    end
    dst.puts str
    return unless @used
    tmpoffset = ""
    tmpoffset << offset + "   "
    @includes.each do | include| 
      include.dump(dst, tmpoffset)
    end
  end

  def getSize()
    size = include.base_size
    @includes.each do | include| 
      if(include.used)
        size += include.getSize 
      end
    end
    return size
  end

end
