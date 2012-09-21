require 'rinda/tuplespace'
$ts = Rinda::TupleSpace.new
DRb.start_service('druby://:12345', $ts)
puts DRb.uri
DRb.thread.join


## require "thread"

## q = Queue.new

## t = Thread.new do
##  loop do
##    n = q.pop
##    if n.to_f>=0
##      val = Math::sqrt(n.to_f)
##      puts "Square(#{n}) = #{val}"
##    else
##      puts "?"
##    end
##  end
## end
## while line = gets
##  if line.chop! == "."
##    break
##  else
##    p line
##    q.push(line)
##  end
## end
