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
		cc.m(); //still prints D because casting only fool the type checker at compile time.
	}
}