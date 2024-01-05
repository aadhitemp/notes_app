// const age = 17;
// //const is used for compile time constants

// final int rate;
// //used for runtime constantts


// var name = 'alex';
// //data type assigned on compile 


// //=============================================Functions and strings==========
// String getFullName(String firstName, String lastName){
//   return firstName + ' ' + lastName;
// }

// String getAnoFullName(String firstName, String lastName){
//   return '$firstName $lastName';
//   //String interpolation, I think so...
// }

// String getoneFullName(String firstName,String lastName)=>'$firstName $lastName';
// //===============close functions===================
// //A function with a return type is considered as void

// void test(){
//   final name= 'Foo';
//   if(name=='Foo'){
//     print('Yes this is foo');
//    }
//   else if(name !='Foo'){
//     print('Not foo');
//   }
//   else{
//     print('nothing');
//   }
//   if(name=='Foo') print('Yes this is foo');//This also works, just as in c and cpp
// }

// void test1(){
//   final age=20;
//   final halfOfAge= age/2;
//   final doubleOfAge= age*2;
//   print(halfOfAge);
//   print(doubleOfAge);
//   //operators are the usual story
//   final name='string123';
//   print(name*100);//prints string123 a hundred times
// }



// void listsInDart(){
//   var names =['foo', 'bar', 'baz'];
//   //Lists: homogenous "things"
//   final foo=names[0];
//   names.add('My names');//Adding to lists
//   final length=names.length;//length of lists
//   print(foo);
//   print(length);
// }


// //SETS in DART:unique list, the normal set things
// void setsINDart(){
// var setname = {'foo', 'bar', 'baz'};//Set syntax
// setname.add('foo');
// }



// //Maps in Dart: Key value pairs, i.e., dictionary
// mapsInDart(){
//   const person={'age': 20, 'name': 'Foo'};//Keys in Maps are unique
//   person['name']='FOOOOOO';
//   person['lastname']='last';
// }


// //==============NULLSAFETY================
// //null is a keyword
// nullsafety(){
//   //Use ? at the end to make a datatype Nullable
//   String? name;//initialized to null by default
//   print(name);
//   name='Foo';
//   name=null;//Changed to null
//   if(name==null){
//     //dosomething;
//   }
//   List<String>? names=['Foo', 'Bar']; //This means that whole list can be null but individual items can't be..
//   List<String?>? tada=['Food', null]; //this null declaration is not possible in the above code=====Optional list of optional strings====
// }

// cherrPickNull(){
//   const String? firstName=null;
//   const String? middleName='bar';
//   const String? lastName='baz';
//   if(firstName != null){
//     //do soemthing;
//   }
//   else if(middleName != null){
//     //do something else
//   }
//   else if(lastName!=null){
//     //somethin else
//   }

//   final firstNonNullValue = firstName ?? middleName ?? lastName;//Picks the first value which isn't null
// }

// nullAwareAssignment(String? firstName, String? middleName, String? lastName){
//   String? name= firstName;
//   name ??= middleName; //changes name to middlename if name isn't null
//   name ??=lastName;
//   //name is only assigned a value, if it is null...
// }

// conditionalInvocation(List<String>? name){
//   var length;
//   if(name!=null){
//     length =name.length;// This promotes the type from null to list, without this, an error would be thrown
//   }//old way of conditionalInvocation
//   else{
//     length=0;
//   }
//   length=name?.length ?? 0; //if name is not null, length is set to it's length, if not it's set to zero.
//   name?.add('Baz');//this wouldn't work without onditional invocation as the receiver can be null
// }

// //========Enumeration//switch statements====================
// //enum is named list of related items, pascal case for declaration
// enum PersonProperties {firstName, lastName, age}
// enumTest(PersonProperties personProperties){
//   switch (personProperties){
//     case PersonProperties.firstName:
//     //dosomething
//       break;//preventing casefallthrough, you know
//     case PersonProperties.lastName:
//     //dosomething
//       break;
//     case PersonProperties.age:
//     //dosomething
//       break;
//   }
// }

// //===========Class/Objects=============
// class Person{
//   final String name;
//   Person(this.name);//constructor
//   //avoid using as much as you can apart form initialization
//   void run(){}
//   breathe(){}
// }
// classTest(){
//   final person=Person('Foo Bar');
//   person.run();
//   person.breathe();
//   print(person.name);
// }

// //=========Inheritance&Subclassing==========
// class LivingThing{
//   void breath(){}
//   void move(){}
// }
// class Cat extends LivingThing{ //cat inherits from livingthings

// }

// //============Abstactclass=============
// //These classes can't be instantiated, these can only be inherited
// abstract class Dog{

// }

// //============Factory Constructors===========
// //==========apparently this is a big thing======
// class Tiger{
//   final String name;
//   Tiger(this.name);
// factory Tiger.fluffBall(){
//   return Tiger('Fluff Ball');
// }
// }

// factoryTest(){
//   final fluffBall= Tiger.fluffBall();
//   print(fluffBall.name);

// }


// //==============Custom Operator===============
// class Human{
//   final String name;
//   Human(this.name);
//   @override//operator overloading
//   bool operator ==(covariant Human other) => other.name==name;//covariant says incoming thing will be Human, other is the other object in the operation
  
//   @override//something which  I don't understand.
//   int get hashCode => name.hashCode;//values are identified using hashcode, that's what we compare with, so..
// }

// //============ADVANCED DART===============
// //==========Extensions=============
// class Class3{
// final String name;
// Class3(this.name);
// }
// extension Run on Class3{
//   void run(){print('tada');}
// }///used to extend functionalit of a clas
// test40(){
// final food = Class3('name');
// food.run();
// }

// class Class4{
//   final String firstName;
//   final String lastName;
//   Class4(this.firstName, this.lastName);
// }
// extension FullName on Class4{//============Getter============
//   String get fullName=>'$firstName $lastName';
//   //The above this is a getter, used to return something...
// }

// //==============FUTURES=============
// Future<int> heavyFutureThatMultipliesbyTwo(int a){
//  return Future.delayed(const Duration(seconds: 3), ()=>a*2);//a Future....delayed has two arguments, a function and a duration
// }

// void test44() async{//declarling the function as asynchronous..
//   final result=await heavyFutureThatMultipliesbyTwo(10);//this is to await a future 
//   print(result);
// }


// //===========Streams===========
// Stream<String> getName(){
//   return Stream.periodic(const Duration(seconds: 1), (value){
//     return 'foo';
//   });
// }
// void test99() async{
//   await for (final value in getName()){
//     print(value);
//   }
// }

// //===========Generators=========
// Iterable<int> getOneTWOThree() sync*{//used sync*for iterables/generator...async* is also these...these are calculated on the go instead, of being prepacked....
//   yield 1;//use yield eahc time you want to return something.
//   yield 2;//
//   yield 3;//
// }
// void tet69(){
//   for(final value in getOneTWOThree()){
//     if(value==2){
//       break;
//     }
//   }
// }


// //=================Generics=====================
// class Pair<A, B>{//<> this indicates, the generics...
// final A value1;
// final A value2;
// Pair(this.value1, this.value2);
// }

// void test45(){
//   final names =Pair('Foo', 20);
//   names;
// }