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
