require_relative "IncludeObj.rb" 

class UsedInclude
  attr_reader:used
  def initialize(used, include)
    @used = used
    @file = include
    @includes  = []
  end

  def markuse(list)
    @file.includes.each do |include| 
      if(not list.include?(include))
        list << include
        @used = true
        @includes << UsedInclude.new(true, include).markuse(list)
      else
        @includes << UsedInclude.new(false, include)
      end
    end
    return self
  end

  def dump(dst, offset = "")
    str = "#{offset} #{@file.name}"
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
    tmpoffset = offset + "   "
    @includes.each do | include| 
      include.dump(dst, tmpoffset)
    end
  end

  def getSize()
    size = @file.base_size
    @includes.each do | include| 
      size += include.getSize  unless include.used
    end
    return size
  end

end
 
