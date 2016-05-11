
// Inheritance

abstract public class Point{
	abstract public negate();
}

public class CartesianPoint extends Point{
	private float x;
	private float y;
}

public class PolarPoint extends Point{
	private float r;
	private float rho;
}

/*
	Inheritance:
		- Derive a new class from existing class
	keyword: extends

	Subtype:
	keyword: implements  
*/

/*
	Interface and implementation:
		Implementation's function signature must match function signature in interface.
		If a function throw exception in implementation but no in interface, there the signature does not match.
*/

class Point {
	public int x, y;
	public boolean isEqual(Point p) {
		return p.x == x && p.y == y; 
	}
}
	
class ColoredPoint extends Point {
	public int color;
	public Boolean isEqual(ColoredPoint p) {
		return p.x == x && p.y == y && p.color == color; 
	}
}

class Main{
	public static void main(String [] args){
		ColoredPoint p,q;
		p = new ColoredPoint();
		p.x = 1; p.y = 2; p.color = 3;
		q = new ColoredPoint();
		q.x = 1; q.y = 2; q.color = 4;
		boolean b1 = p.isEqual(q); // b1???
		Point r = (Point) q;
		boolean b2 =  p.isEqual(r); // b2???
		System.out.println(b1);  //false
		System.out.println(b2);  //true
	}
}




abstract public class Shape{
	abstract double area();
	abstract double perimeter();
}

public class Point{
	private double x;
	private double y;
	public Point(double x, double y){
		this.x = x;
		this.y = y;
	}
}

public class Rectangle extends Shape{
	private Point p;
	private double width;
	private double height;
	public Rectangle(Point p, double width, double height){
		this.p = p;
		this.width = width;
		this.height = height;
	}
	double area(){
		return width*height;
	}
	double perimeter(){
		return 2*(width+height);
	}
}

public class Circle extends Shape{
	private double radius;
	private double center;
	public Circle(Point center, double radius){
		this.radius = radius;
		this.center = center;
	}
	double area(){
		return 3.14*radius*radius;
	}
	double perimeter(){
		return 2*3.14*radius;
	}
}

