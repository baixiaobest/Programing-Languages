/* Name:

   UID: 504313981

   Others With Whom I Discussed Things:

   Other Resources I Consulted:
   http://docs.oracle.com/javase/8/docs/api/
*/

// import lists and other data structures from the Java standard library
import java.util.*;

// PROBLEM 1

// a type for arithmetic expressions
interface Exp {
    double eval();                          // Problem 1a
    List<Instr> compile();                  // Problem 1c
}

class Num implements Exp {
    protected double val;

    Num(double value){val = value;}

    public boolean equals(Object o) { return (o instanceof Num) && ((Num)o).val == this.val; }

    public String toString() { return "" + val; }

    public double eval(){return val;}

    public List<Instr> compile(){
        List<Instr> newInstr = new LinkedList<Instr>(); 
        newInstr.add(new Push(val));
        return newInstr;
    }
}

class BinOp implements Exp {
    protected Exp left, right;
    protected Op op;

    BinOp(Exp l, Op o, Exp r){
        left = l;
        op = o;
        right = r;
    }

    public boolean equals(Object o) {
        if(!(o instanceof BinOp))
            return false;
        BinOp b = (BinOp) o;
        return this.left.equals(b.left) && this.op.equals(b.op) &&
                this.right.equals(b.right);
    }

    public String toString() {
        return "BinOp(" + left + ", " + op + ", " + right + ")";
    }

    public double eval(){
        return op.calculate(left.eval(),right.eval());
    }

    public List<Instr> compile(){
        List<Instr> newInstr = new LinkedList<Instr>();
        newInstr.addAll(left.compile());
        newInstr.addAll(right.compile());
        newInstr.add(new Calculate(op));
        return newInstr;
    }
}

// a representation of four arithmetic operators
enum Op {
    PLUS { public double calculate(double a1, double a2) { return a1 + a2; } },
    MINUS { public double calculate(double a1, double a2) { return a1 - a2; } },
    TIMES { public double calculate(double a1, double a2) { return a1 * a2; } },
    DIVIDE { public double calculate(double a1, double a2) { return a1 / a2; } };

    abstract double calculate(double a1, double a2);
}

// a type for arithmetic instructions
interface Instr {
    public void doit(Stack<Double> st);
}

class Push implements Instr {
    protected double val;

    Push(double value){
        val = value;
    }

    public void doit(Stack<Double> st){
        st.push(val);
    }

    public boolean equals(Object o) { return (o instanceof Push) && ((Push)o).val == this.val; }

    public String toString() {
        return "Push " + val;
    }

}

class Calculate implements Instr {
    protected Op op;

    Calculate(Op o){
        op = o;
    }

    public void doit(Stack<Double> st){
        double b = st.pop();
        double a = st.pop();
        st.push(op.calculate(a,b));
    }

    public boolean equals(Object o) { return (o instanceof Calculate) && 
                              ((Calculate)o).op.equals(this.op); }

    public String toString() {
        return "Calculate " + op;
    }    
}

class Instrs {
    protected List<Instr> instrs;

    private Stack<Double> stack;

    public Instrs(List<Instr> instrs) { this.instrs = instrs; stack = new Stack<Double>();}

    public double execute() {
        for(Instr ins : instrs){
            ins.doit(stack);
        }
        return stack.pop();
    } 
}


class CalcTest {
    public static void main(String[] args) {
        // a test for Problem 1a
        Exp exp = new Num(10.0);
        assert(exp.eval() == 10.0);
        Exp exp2 = new BinOp(new BinOp(new Num(1.0),Op.PLUS, new Num(2.0)),Op.DIVIDE,new Num(2.0));
        assert(exp2.eval() == 1.5);

        exp =
         new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)),
                   Op.TIMES,
                   new Num(3.0));
        assert(exp.eval() == 9.0);

        // a test for Problem 1b
        List<Instr> is = new LinkedList<Instr>();
        is.add(new Push(1.0));
        is.add(new Push(2.0));
        is.add(new Calculate(Op.PLUS));
        is.add(new Push(3.0));
        is.add(new Calculate(Op.TIMES));
        Instrs instrs = new Instrs(is);
        assert(instrs.execute() == 9.0);

        List<Instr> is2 = new LinkedList<Instr>();
        is2.add(new Push(1.0));
        is2.add(new Push(2.0));
        is2.add(new Calculate(Op.DIVIDE));
        is2.add(new Push(4.0));
        is2.add(new Calculate(Op.TIMES));
        is2.add(new Push(1.0));
        is2.add(new Calculate(Op.MINUS));
        instrs = new Instrs(is2);
        assert(instrs.execute() == 1.0);

        // a test for Problem 1c
        assert(exp.compile().equals(is));
        assert((new Instrs(exp2.compile())).execute() == 1.5);
    }
}


// PROBLEM 2

// the type for a set of strings
interface StringSet {
    int size();
    boolean contains(String s);
    void add(String s);
}

// an implementation of StringSet using a linked list
class ListStringSet implements StringSet {
    protected SNode head;
    ListStringSet(){head = new SEmpty();}
    public int size(){return head.size();}
    public boolean contains(String s){return head.contains(s);}
    public void add(String s){head = head.add(s);}
}

// a type for the nodes of the linked list
interface SNode {
    int size();
    boolean contains(String s);
    SNode add(String s);
}

// represents an empty node (which ends a linked list)
class SEmpty implements SNode {
    public int size(){return 0;}
    public boolean contains(String s){return false;}
    public SNode add(String s){return new SElement(s);}
}

// represents a non-empty node
class SElement implements SNode {
    protected String elem;
    protected SNode next;

    SElement(String s){elem = s; next = new SEmpty();}

    public int size(){return 1+next.size();}

    public boolean contains(String s){
        if(s.compareTo(elem)==0)
            return true;
        else
            return next.contains(s);
    }

    public SNode add(String s){
        int comVal = s.compareTo(elem);
        // s < elem
        if(comVal < 0){
            SElement newNode = new SElement(s);
            newNode.next = this;
            return newNode;
        }else if(comVal == 0){
            return this;
        }else{ // s > elem
            next = next.add(s);
            return this;
        }
    }
}



interface Set<T>{
    int size();
    boolean contains(T s);
    void add(T s);
    void print();
}

class ListSet<T> implements Set<T>{
    protected Node<T> head;

    Comparator<T> comp;
    ListSet(Comparator<T> comp){this.comp = comp; head = new Empty<T>();}

    public int size(){return head.size();}

    public boolean contains(T s){return head.contains(s,comp);}

    public void add(T s){head = head.add(s,comp);}

    public void print(){head.print();}
}

interface Node<T>{
    int size();
    boolean contains(T s, Comparator<T> comp);
    Node<T> add(T s, Comparator<T> comp);
    void print();
}

class Empty<T> implements Node<T>{
    public int size(){return 0;}
    public boolean contains(T s, Comparator<T> comp){return false;}
    public Node<T> add(T s, Comparator<T> comp){return new Element<T>(s);}
    public void print(){}
}

class Element<T> implements Node<T>{
    protected T elem;
    protected Node<T> next;

    Element(T e){elem = e; next = new Empty<T>();}

    public int size(){return 1+next.size();}

    public boolean contains(T s, Comparator<T> comp){
        if(comp.compare(s,elem)==0)
            return true;
        else
            return next.contains(s,comp);
    }

    public Node<T> add(T s, Comparator<T> comp){
        int compVal = comp.compare(s, elem);
        // s < elem insert the element
        if(compVal < 0){
            Element<T> newNode = new Element<T>(s);
            newNode.next = this;
            return newNode;
        }else if(compVal == 0){  // duplicate
            return this;
        }else{  // s > elem
            next = next.add(s,comp);
            return this;
        }
    }

    public void print(){System.out.println(elem); next.print();}
}
