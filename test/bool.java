interface Bool {
Bool logicalAnd(Bool b);
void ifThenElse(CodeBlock b1, CodeBlock b2);
}
interface CodeBlock { void execute(); }

class False implements Bool{
	public Bool logicalAnd(Bool b){
		return new False();
	}

	public void ifThenElse(CodeBlock b1, CodeBlock b2){
		b2.execute();
	}
}

class True implements Bool{
	public Bool logicalAnd(Bool b){
		return b;
	}
	public void ifThenElse(CodeBlock b1, CodeBlock b2){
		b1.execute();
	}
}

class Loops{
	void whileTrue(LoopGuard guard, CodeBlock body){
		Bool res = gard.evaluate();
		res.ifThenElse(
			new CodeBlock(){public void execute(){body.execute; new Loops().whileTrue(guard,body);}},
			new CodeBlock(){public void execute() {return;}}
		);
	}
}

class booltest{
	public static void main(String [] args){
		Bool b1 = new False();
		Bool b2 = new True();
		Bool b3 = b1.logicalAnd(b2);
		b3.ifThenElse(
		new CodeBlock() { public void execute() { System.out.println("hi!"); }},
		new CodeBlock() { public void execute() { System.out.println("bye!"); }}
		);
	}
}