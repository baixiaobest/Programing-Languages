class C{
	void n(){this.m();}
	void m(){System.out.println("C");}
	void a(){System.out.println("A");}
}

class D extends C{
	void m() {System.out.println("D");}
	void foo(){};
}

class Main{
	public static void main(String [] args){
		C c = new C();
		D d = new D();
		C c2 = new D();
		// D d2 = new C(); //compile time error, because C is not a subtype of D
		c.m();   // prints C
		d.m();   // prints D d is actually D so it prints D
   		c2.m();  // prints D

   		c.n();   //print C
		d.n();   //print D  this.m() is pointing at D.m()
   		c2.n();  //print D  this.m() is pointing at D.m()
   		// c2.foo(); //this creates error on compile time because c2 is of static type C, static typechecking cannont find funciton called foo in C
   		((D) c2).foo(); //tell type checker to treat c2 as D, then there is not compile error, foo() can be invoked during run time
   		((C) d).m(); //still prints D because fooling typechecker that it is C does not change the fact that it is still D
		C cc = (C) d;
		cc.m();  //still prints D because casting only fool the type checker at compile time.
	}
}


class A{}
class B extends A{}

class X{
	void m(A a){System.out.println("X,A");}
}

class Y extends X{
	void m(B b) {System.out.println("Y,B");}
}

class Stuff{
	public static void main(String [] args){
		X x = new Y();
		Y y = new Y();
		x.m(new A());   // prints X,A, because parameter and argument match with X.m(A)
		x.m(new B());   // prints X,A, because x is statically X, then X.m(A) is invoked
		y.m(new A());  // prints X,A, because m(A) is statically determined
		y.m(new B());  // prints X,B, because statically m(B) is invoked
	}
}


class J{
	void m(A a){System.out.println("J,A");}
	void m(B b){System.out.println("J,B");}
}

class K extends J{
	void m(A a){System.out.println("K,A");}
	void m(B b) {System.out.println("K,B");}
}

class Stuff2{
	public static void main(String [] args){
		J j = new K();
		K k = new K();
		j.m(new A());   // prints K,A, J.m(A) and K.m(A) are selected in static phase, K.m(A) is invoked in dynamic phase
		j.m(new B());   // prints K,B, J.m(B) and K.m(B) in static phase, K.m(B) in dynamic phase
		k.m(new A());  // prints K,A
		k.m(new B());  // pirnts K,B
	}
}