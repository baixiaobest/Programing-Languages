// parametric polymorphism
interface List<T>{
	void add(T t);
	boolean contains(T t);
	T get(int i);  // you are guaranteed to get type that you instantiated.
}

// subtype polymorphism

interface C {
	// ...
}

interface D extends C{
	// ...
}

class Client {
	void doSomething(C c){
		// ...
	}
}

// why do we need parametric polymorhpism if we can do the same thing this way
interface ObjectList{
	void add(Object o);
	boolean contains(Object o);
	Object get(int i);  // you only get object, but you don't know the type
}
/*
	1. ObjectList can contain any kind of object
		- a single list can contain strings, integer, doubles, foos, etc
		- ObjectList can contain heterogeneous objects in the list
	2. Parametric polymorphism can correlate input and output types. Subtyping cannot.
		Ex:
*/
class Main{
	void m(List<String> l, ObjectList l2){
			l1.add("hi");
			l1.add("bye");
			l1.add(new Integer(43)); // Get a type error on compile time
			String s = l1.get(0); //I know I can get back a string from List.get()

			l2.add("hi");
			l2.add("bye");
			l2.add(new Integer(43));
			String s = l2.get(0);    // static error because it returns object. You need to cast
			String s = (String)l2.get(0) // compile OK. But returned object may not be string. You may get run time error.
	}
}

// Animal Example

interface Animal{
	void eat(){}
}

interface Cow extends Animal{
	void moo(){}
}

// T can be Animal or cow, AnimalList is subclass of List.
class AnimialList<T extends Animal> implements List<T>{
	public void add(T t){
		t.eat();
	}
}


// Dynamic dispatch and static overloading

class C{
	void m(String s){}
	void m(Integer i){}

	void n(Animal a){}
	void n(Cow c){}
}

class Main2{
	void doit(){
		C c = new C();
		c.m("hi");   //method determined at compile time
		c.m(34);     //method determined at compile time
	}

	void doit2(Animal a, Cow cow){
		C c. = new C();
		c.n(a);        // Statically determined invoke n(Animal)
		c.n(cow);      // Statically determined invoke n(Cow)
		Animal a2 = cow;
		c.n(a2);       //Static type of a2 is Animal, so n(Animal) is invoked
	}
}


// Static overloading

class A{}
class B extends A{}

class X{
	void m(A a){System.out.println("X,A");}
}

class Y extends X{
	void m(B b) {System.out.println("Y,B");}
}

class Stuff{
	void stuff(){
		X x = new Y();
		x.m(new A());   // prints X,A, because parameter and argument match with X.m(A)
		x.m(new B());   // prints X,A, because x is statically X, then X.m(A) is invoked
	}
}

/*	KeyPoint:
	if two methods have the same name but either different number of args
	or different parameters type, then they are treated as if they 
	have different names
*/

/*
	two phases of method lookup:
	static phase: based on the static types of the
	parameters, we find the right "method family"
	- method name plus argument types

	dynamic phase: dynamic dispatch on the receiver 
	object, over the methods from the statically
	chosen method family
*/
class X{
	void m(A a){System.out.println("X,A");}
	void m(B b){System.out.println("X,B");}
}

class Y extends A{
	void m(A a){System.out.println("Y,A")}
	void m(B b) {System.out.println("Y,B");}
}

class Stuff{
	void stuff(){
		X x = new Y();
		x.m(new A());   // print Y,A , statically determines X.m(A a) Y.m(A a) family methods, dynamically determines Y.m(A a)
		x.m(new B());   // print Y,B , statically determines X.m(B b) Y.m(B b) family methods, dynamically determines Y.m(B b)
	}
}

/*
00 style: each object know how to do certain things. specified by some kind of interface.

client should be able to manipulate the object just through that interface
*/

// imperative sets BAD 00 STYLE

class Set{
	int[] arr;

	boolean contains(int i){
		// ...
	}
}



// Sorting

class MyComparator implements Comparator<String>{
	public int compare(String s1, Sting s2){
		return s2.length()-s1.length();
	}
}

class Sorting{
	public static void main(String[] args){
		List<String> l = new LinkedList<String>();
		for(String s: args)
			l.add(s);
		Collection.sort(l, new MyComparator());
		Collection.sort(l, (s1,s2) -> s1.length()-s2.length()); // lambda in java
		System.out.println(l);
	}
}




