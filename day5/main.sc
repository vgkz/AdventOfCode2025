import scala.io.Source._

def splitRanges(s:String):Array[Long]={
  val ss = s.split("-").map(_.toLong)
  return ss 
}

def readInput(input:List[String]) : Tuple = {
  val split_index:Int = input.indexOf("")
  val ranges:List[Array[Long]] = input.slice(0,split_index).map(splitRanges)
  val targets:List[Long]= input.slice(split_index+1,input.length).map(_.toLong)
  return (ranges, targets)
}

def inRange(x:Long, range:Array[Long]):Boolean = {
  val min = range(0)
  val max = range(1)
  return (min <= x) && (x <= max)
}

def inAnyRange(x:Long, ranges:List[Array[Long]]):Boolean = {
  val t = ranges.map(inRange(x, _))
  t.exists(_==true)
}

val test_input = List("3-5", "10-14", "16-20", "12-18", "", "1", "5", "8", "11", "17", "32")

def main() = {
  // read data
  val lines = fromFile("data.txt").getLines.toList
  val (xx,yy):(List[Array[Long]],List[Long]) = readInput(lines)
   // solve part 1
  println(yy.map(inAnyRange(_,xx)).count(_==true))
}

// run script
main()
