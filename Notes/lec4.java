/*
Java version 8

SEAS machines: /usr/local/cs/bin{java,javac}


three key concepts:

subtyping
inheritance
dynamic dispatch

key idea:

everything is an object
objects only communicate by sending messages

separation of interface and implementation

Two forms of polymorphism:

- parametric polymorphism
	Some type is parameterized by one or more type variables

*/
import java.util.*;

// a type for set of strings
interface Set {
	boolean contains(String s);
	void add(String s);
}

// implementation
class ListSet implements Set {
	protected List<String> elems = new LinkedList<String>();

	public boolean contains (String s){
		return elems.contains(s);
	}

	public void add(String s){
		if(this.contains(s))
			return;
		else
			elems.add(s);
	}
}

// parametric polymorphism
interface PolySet<T>{
	boolean contains(T t);
	void add(T t);
}

/*
	Java has a second kind of polymorphism:
	- subtype polymorphism

	there;s a subtype relation on types

	if S is a subtype of T, then you can pass an object of type S where an object of type T is expected.

	Example: RemovableSet is a subtype of set

	keyword: extends  to represent subtype
	RemovableSet is subtype of Set, so where class Client expects Set can be passed with RemovableSet
*/

interface RemovableSet extends Set{
	void remove(String s);
}

/*
	Inheritance

	Reuse the implementation
*/

class RemovableListSet extends ListSet implements RemovableSet{
	// declare linked list

	// declare add

	// declare contains

	// declare remove

	// But Programmer is lazy, use inheritance
	public void remove(String s){
		elems.remove(s);
	}
	
}

class Client{
	// pass Set or RemovableSet are OK
	void m(Set s){
		if(s.contains("hi"))
			s.add("bye");
	}
	// pass RemovableSet ONLY
	void n(RemovableSet rs){
		this.m(rs);
	}
}

// Subtyping without inheritance
// Sqaure is subtype of Rectangle, where is expected to pass Rectangle, Square can be passed.
// Donnot implement Square inheriting Rectangle

interface Shape{
	double area();
	double perimeter();
}

class Rectangle implements Shape {

}
class Square implements Shape{

}

class MyClient{
	void m(Shape s){}
}



// Inheritance without subtyping
// suppose we have ListSet

/* we want to implement bags
	- sets that can contain duplicates

	claim: we want ListBag to inherit code from ListSet, but ListBag should not be a subtype of ListSet
	Because ListBag contains code common to ListSet
*/

// another option: shared superclass of both ListBag and ListSet

abstract Collection{
	protected List<String> elems = new LinkedList<String>();

	public boolean contains (String s){
		return elems.contains(s);
	}
}

class ListSet extends Collection{
	void add(String s) {}
}

class ListBag extends Collection{
	void add(String s) {}
}


/*	In Summary
	When we need subtyping without inheritance: implement shared interface
				 inheritance without subtyping: extend shared abstract class
*/















