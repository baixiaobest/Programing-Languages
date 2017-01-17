class dummy{
	public int x;
	public dummy(){
		x = 0;
	}
}

class Main{
    public static void main(String [] args){
        dummy x = new dummy();
        dummy y = new dummy();
        String s = new String("hello");
        String str = new String("hello");
        String ss = "hello";
        String strs = "hello";
        System.out.println(x.equals(y));
        System.out.println(x==y);
        System.out.println(s.equals(str));
        System.out.println(s==str);
        System.out.println(ss.equals(strs));
        System.out.println(ss==strs);
    }
}

// interface Greeter {
// void greet();
// }
// class Person implements Greeter {
// public void greet() { this.hello(new Integer(3)); }
// public void hello(Object o) { System.out.println("hello object"); }
// }
// class CSPerson extends Person {
// public void hello(Object o) { System.out.println("hello world!"); }
// }
// class FrenchPerson extends Person {
// public void hello(Object o) { System.out.println("bonjour object"); }
// public void hello(String s) { System.out.println("bonjour " + s); }
// }

class Person {
public void greet() { this.hello(new Integer(3)); }
public void hello(Object o) { System.out.println("hello object"); }
}
class CSPerson extends Person {
public void hello(Object o) { System.out.println("hello world!"); }
}


class GreeterTest{
    public static void main(String [] args){
        CSPerson p = new CSPerson();
        p.greet();
    }
}
