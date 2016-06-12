require "find"
require_relative "Config.rb"
require_relative "IncludeList.rb" 
require_relative "PaserInfo.rb" 
require_relative "Utils.rb" 

class IncludeTree
  def  initialize(config)
    @config = config
    @list = IncludeList.new(config.include_search_path)
  end

  def paser()
    outList = getfiles.map{ |file| PaserInfo.new(file, @list) }
    output(outList)
  end

  private

  def getfiles
    matcher = @config.getMatcher
    return Find.find(@config.search_path).select{ |file| matcher.include(file) }
  end

  def output(outList)
    dst = File.new(@config.output_path, "w+")
    list = outList.sort do |a, b| 
      a.sum <=> b.sum
    end
    list.each {|cpp| cpp.output(dst)}
    dst.close
  end
end



$paser = lambda{|| IncludeTree.new(IncludeTreeConfig.new).paser}
$help = lambda{|| p "this is a help"}
options = {"help:"=>["give how to use", $help],
           "paser"=> ["paser the file config in the config file", $paser]}

ARGV.each do |arg| 
  if options.each_key.include?(arg)
    options[arg][1].call
  else
    p "#{arg} is not define in list"
  end
end
if(ARGV.empty? )
  p "Follow option is provided"
  options.each do |var| 
    p "#{var[0]} : #{var[1][0]} "
  end
end
puts "====Current input arg is #{ARGV}===="
