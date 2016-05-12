// Exception in JAVA

interface List{
	void add(String s);
	String get throws OutOfBoundsAccess,Exn2 (int i);

}

class OutOfBoundsAccess extends Exception{}

class Exn2 extends Exception{}

class MyList implements List{
	public void add(String s){}

	public String get(int i) 
		throws OutOfBoundsAccess, Exn2{
		if (i<0)
			throw new OutOfBoundsAccess();
		else if(i>20)
			throw new Exn2();
		return "hi";
	}

	public String callsGet(int i) throws OutOfBoundsAccess{
		try{
			return this.get(i);
		}catch(Exn2 e){
			return "exn2 error";
		}
	}
}

class Client{
	void m() throws OutOfBoundsAccess{
		List l = new MyList();
		String s = l.get(0);
	}

	public static void main(String [] args) 
		throws OutOfBoundsAccess{
			try{
				new Client.m();
			}catch(Exn2 e){}
		}
}


/* Problem
	I call a function get() it throws an exception

	How do I get back to a safe state of memory,
	in order to continue executing?

	"exception safty"
*/

class X{}

class Y{}

class XException extends Exception{}
class YException extends Exception{}

class Example{
	X x;
	Y y;

	void updateX() throws XException{
		// do some computation
		// update the value this.x
	}

	void updateY() throws YException{
		// do some computation
		// update the value this.y
	}

	// either both get updated or neither get updated
	void updateBoth() 
		throws XException, YException{

		X oldx = this.x;
		updateX();
		try{
			updateY();
		}catch(YException ye){
			this.x = oldx;
			throw ye;
		}
	}

	void readFileAndCompute(File f){
		String s = f.read();
		try{
			compute(s);
		}finally{          // whether exception is thrown, close the file
			f.close();
		}
	}
}




Set s = new ListSet(); //s is on the stack, new object is on the heap, s points to new object
s.add("hi"); //dereferencing s and updating the object on the heap
Set s2 = s; // s2 now points to the object on the heap
s2.remove("hi") // s no longer contains "hi"


/*
	Parameter passing

	In java, parameter passing is by value:
		the value of the actual parameter is copied into the formal parameter
		But the values are always pointers, except for premitives
	key property: the value of the actual parameter cannot be changed by the function call
*/

int plus(int a, int b){
	a += b;
	return a;
}

void f(){
	int x = 3;
	int y = 4;
	int z = plus(x,y);
}

// x is 3, y is 4, z is 7

class Integer{
	int i;
	Integer(int val){this.i = val;}
}

Integer plus(Integer a, Integer b){
	a = new Integer(a.i+b.i);
	return a;
}

Integer x = new Integer(3);
Integer y = new Integer(4);
Integer z = plus(x,y);
// x = 3, y = 4, z = 7


/////////// Call by reference in C++

int plus(int& a, int& b){
	a += b;
	return a;
}

void f(){
	int x = 3;
	int y = 4;
	int z = plus(x,y);
}




