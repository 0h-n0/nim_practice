import os
from strutils import parseInt, intToStr

echo("hello world")
var
  x = 1
  y: int
  a, b, c: string
  nam: string
const
  A = 5
let
  let_value = A

  # let input
a = "hello world 2"    
echo(x)
echo(a, " ", x)
echo(let_value)
echo(A)
# The difference between let and const is: let introduces a variable that can not be re-assigned,  const means "enforce compile time evaluation and put it into a data section":
echo(1..4)

for i in 1..<10:
  echo(i)

for i in 1..10:
  echo(i)

for i in countup(1, 10, 2):
  echo(i)

for i in countdown(10, 1, 2):
  echo(i)
  
var s = "some string"

for i in s:
  echo(i)
  
for index, item in ["a", "3"].pairs:
  echo index, item

block:
  var x = "hi"
  echo x

block myblock:
  var x = "hi form myblock"
  echo x
  
block myblock:
  echo "entering block"
  while true:
    echo "looping"
    break # leaves the loop, but not the block
  echo "still in block"

block myblock2:
  echo "entering block"
  while true:
    echo "looping"
    break myblock2 # leaves the block (and the loop)
  echo "still in block"

when system.hostOS == "windows":
  echo "running on Windows!"
elif system.hostOS == "linux":
  echo "running on Linux!"
elif system.hostOS == "macosx":
  echo "running on Mac OS X!"
else:
  echo "unknown operating system"

#[
* Each condition must be a constant expression since it is evaluated by the compiler.
* The statements within a branch do not open a new scope.
* The compiler checks the semantics and produces code only for the statements that belong to the first condition that evaluates to true.
]#
proc yes(question: string): bool =
  echo question, " (y/n)"
  while true:
    case readLine(stdin)
    of "y", "Y", "yes", "Yes": return true
    of "n", "N", "no", "No": return false
    else: echo "Please be clear: yes or no"
    
if yes("Should I delete all your important files?"):
  echo "I'm sorry Dave, I'm afraid I can't do that."
else:
  echo "I think you know what the problem is just as well as I do."


proc sumTillNegative(x: varargs[int]): int =
  for i in x:
    if i < 0:
      return
    result = result + i

echo sumTillNegative() # echos 0
echo sumTillNegative(3, 4, 5) # echos 12
echo sumTillNegative(3, 4 , -1 , 6) # echos 7  

#[
A procedure that returns a value has an implicit result variable declared that represents the return value. A return statement with no expression is a shorthand for return result. The  result value is always returned automatically at the end of a procedure if there is no return statement at the exit
]#

proc divmod(a, b: int; res, remainder: var int) =
  res = a div b        # integer division
  remainder = a mod b  # integer modulo operation

var
  xx, yy: int
divmod(8, 5, xx, yy) # modifies x and y
echo xx
echo yy

#[
To call a procedure that returns a value just for its side effects and ignoring its return value, a  discard statement must be used. Nim does not allow silently throwing away a return value:
]#

proc p(x, y: int): int {.discardable.} =
  return x + y

echo p(3, 4) # now valid


# overloaded
proc toString(x: int): string =
  # return intToStr(x)
  return $(x)
proc toString(x: bool): string =
  if x: result = "true"
  else: result = "false"

echo toString(13)   # calls the toString(x: int) proc
echo toString(true) # calls the toString(x: bool) proc


if `==`( `+`(3, 4), 7): echo "True"

proc even(n: int): bool

proc odd(n: int): bool =
  assert(n >= 0) # makes sure we don't run into negative recursion
  if n == 0: false
  else:
    n == 1 or even(n-1)
    
proc even(n: int): bool =
  assert(n >= 0) # makes sure we don't run into negative recursion
  if n == 1: false
  else:
    n == 0 or odd(n-1)

type
  Direction = enum
    north, east, south, west

var xxx = south     # `x` is of type `Direction`; its value is `south`
echo xxx

type
  MySubrange = range[0..5]
  
# MySubrange is a subrange of int which can only hold the values 0 to 5. Assigning any other value to a variable of type MySubrange is a compile-time or runtime error. Assignments from the base type to one of its subrange types (and vice versa) are allowed.

var yyy: MySubrange = 3

echo yyy

type
  CharSet =  set[char]
var
  cc: CharSet
cc = {'a'..'z', '0'..'9'}
echo cc

type
  two_dimension = array[0..5, array[0..5, float32]]

var
  x2d_f: two_dimension
  x2d_i: array[0..5, array[0..5, int]]

x2d_f[0][0] = 1.0
x2d_i[0][0] = 100
echo x2d_f
echo x2d_i
echo high(x2d_f)

var
  seq_x: seq[int]

seq_x = @[1, 2, 3]
echo seq_x
# Sequence variables are initialized with nil. However, most sequence operations cannot deal with  nil (leading to an exception being raised) for performance reasons. Thus one should use empty sequences @[] rather than nil as the empty value. But @[] creates a sequence object on the heap, so there is a trade-off to be made here.

# A varargs parameter is like an openarray parameter. However, it is also a means to implement passing a variable number of arguments to a procedure. The compiler converts the list of arguments to an array automatically:

proc myWriteln(f: File, a: varargs[string]) =
  for s in items(a):
    write(f, s)
  write(f, "\n")

myWriteln(stdout, "abc", "def", "xyz")
# is transformed by the compiler to:
myWriteln(stdout, ["abc", "def", "xyz"])

var first_slice: range[1..10]

type
  Person = tuple[name: string, age: int] # type representing a person:
                                         # a person consists of a name
                                         # and an age
var
  person: Person
person = (name: "Peter", age: 30)

echo person
echo person.name
echo person.age
echo person[0]
echo person[1]


type
  Node = ref object
    le, ri: Node
    data: int
var
  n: Node
new(n)
n.data = 9
echo n.data

#[
Nim distinguishes between traced and untraced references. Untraced references are also called pointers. Traced references point to objects in a garbage collected heap, untraced references point to manually allocated objects or to objects elsewhere in memory. Thus untraced references are unsafe. However for certain low-level operations (e.g., accessing the hardware), untraced references are necessary.

Traced references are declared with the ref keyword; untraced references are declared with the ptr keyword.
]#

proc echoItem(x: int) = echo x

proc forEach(action: proc (x: int)) =
  const
    data = [2, 3, 5, 7, 11]
  for d in items(data):
    action(d)

forEach(echoItem)

#[
Nim supports splitting a program into pieces with a module concept. Each module is in its own file. Modules enable information hiding and separate compilation. A module may gain access to the symbols of another module by using the import statement. Only top-level symbols that are marked with an asterisk (*) are exported:
]#

# import mymodule except y
