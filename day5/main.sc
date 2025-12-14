import scala.io.Source._

def splitRanges(s:String):Array[Long]={
  // split string ranges into an array of two values, 
  // 0 being lower bound and 1 being upper bound
  val ss = s.split("-").map(_.toLong)
  return ss 
}

def readInput(input:List[String]) : Tuple = {
  // read input into tuple of ranges and ids
  val split_index:Int = input.indexOf("")
  val ranges:List[Array[Long]] = input.slice(0,split_index).map(splitRanges)
  val ids:List[Long]= input.slice(split_index+1,input.length).map(_.toLong)
  return (ranges, ids)
}

def inRange(x:Long, range:Array[Long]):Boolean = {
  // check if a value is in a range
  val min = range(0)
  val max = range(1)
  return (min <= x) && (x <= max)
}

def inAnyRange(x:Long, ranges:List[Array[Long]]):Boolean = {
  // check if value is in any range in a list of ranges
  val t = ranges.map(inRange(x, _))
  t.exists(_==true)
}

def lengthRangeInclusive(range:Array[Long]):Long = {
  // compute length of inclusive array
  val min = range(0)
  val max = range(1)
  return max - min + 1L
}

def combineAdjacent(ranges:List[Array[Long]]):List[Array[Long]] = {
  // given a sorted list of ranges, combine ranges if they overlap
  ranges.foldLeft(List.empty[Array[Long]]) { (acc, current) =>
    acc match {
      case Nil => current :: Nil
      case head :: tail =>
        if(inRange(current(0), head)) {
          if(current(1)>head(1)){
            Array(head(0),current(1))::tail
          } else {
            Array(head(0),head(1))::tail
          }
        } else {
          current :: acc
        }
    }
  }.reverse
}

def sortRanges(range1:Array[Long],range2:Array[Long]):Boolean = {
  // sort ranges by lower bound and then upper bound
  if(range1(0)<range2(0)){
    return true
  } else if(range1(0)==range2(0)){
    if(range1(1)<range2(1)){
      return true
    } 
  }
  return false
}

def main() = {
  // read data
  val lines = fromFile("data.txt").getLines.toList
  val (ranges,ids):(List[Array[Long]],List[Long]) = readInput(lines)
  // remove redundancies in list of ranges
  val necessary_ranges = combineAdjacent(ranges.sortWith(sortRanges(_,_)))
   // solve part 1
  println(ids.map(inAnyRange(_,necessary_ranges)).count(_==true))
  // solve part 2
  val s = necessary_ranges.map(lengthRangeInclusive(_)).fold(0L)((acc,cur) => acc + cur)
  println(s)
}

// run script
main()
