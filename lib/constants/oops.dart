//class ClassName {
// class properties
// class methods
// }
//RULE - CLASS NAME SHOULD ALWAYS HAVE EVERY WORD'S FIRST CHARACTER CAPITAL
//classname = ClassName

//this keyword
//Constructor - Something that builds

//super keyword
//It is referring to the super class's available properties and methods

//final keyword
//After assigning a value, it doesn't allow you to change the value

//const keyword
//Anything that doesn't change that is a constant

const String cd = "10";

///EXECUTION LOGIC
void main() {
  ArithmeticOperations obj1 = ArithmeticOperations(1000);

  obj1.printTest();

  ArithmeticOperations obj2 = ArithmeticOperations.xyz(a: 30, b: 40, xy: 1000);

  obj2.printTest();

  ArithmeticOperations.cd;

  print("${obj2}");
  print("${obj2.a}");
  print("${obj2.b}");
  print("SUM IS ${obj2.sum()}");
}

///BUSINESS LOGIC
class ArithmeticOperations {
  int? a = 10;
  int? b = 20;

  final int xy;

  static const cd = 10;

  ArithmeticOperations(this.xy);

  void printTest() {
    print("a = $a");
    print("b = $b");
  }

  ArithmeticOperations.xyz({this.a, this.b, required this.xy});

  int sum() {
    return a! + b!;
  }
}
