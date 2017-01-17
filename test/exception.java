class Exn extends Exception{}
class Exn2 extends Exception{}
class Exn3 extends Exception{}

class exceptionTest{

	public void m() throws Exn, Exn2{
		throw new Exn();
	}

	public void n() throws Exn, Exn2{
		m();
	}

	public static void main(String [] args){
		exceptionTest test = new exceptionTest();
		try{
			test.n();
		}catch (Exn e){

		}catch (Exn2 e){

		}
	}
}