// Parallel Computing

/*
1. We can no longer use Moore's law to speed up sequential programming.
Now we're using Moore's law to double number of core every two years.

2. Big Data. Distributed programming. Programming across clusters of machines
or data center.


*/


// automatic parallelization
/*
today exists for "Emabarrasingly parallel"
operations: maps, reduce, filter

Big Data: Google MapReduce, Hadoop, Spark,

Java streams provides similar functionality for single machine.
*/
import java.util.Arrays;
import java.util.Concurrent;

class Sum{
	public static void main(String[] args){
		int size = Integer.parseInt(args[0]);
		int[] arr = new arr[size];
		for(int i=0; i<size; i++){
			arr[i] = i;
		}
		int sum = Arrays.stream(arr)
						.parallel()
			  			.reduce(0,(i1,i2)->i1+i2)
		System.out.println(sum);
	}
}

class Sort{
	public static void main(String[] args){
		int size = Integer.parseInt(args[0]);
		double[] arr = new arr[size];
		for(int i=0; i<size; i++){
			arr[i] = Math.random()*size;
		}
		int[] out = Arrays.stream(arr)
						  .parallel()
			  			  .sorted()
			  			  .toArray();
		for(int i=0; i<10; i++)
			System.out.println(out[i]);
	}
}

/*
class ForkJoinTask<V>{
	void fork(){
	 	// Create new thread
		// invoke this.compute() in new thread
	}

	V join(){
		// wait for new thread to finish
		// return its result.
	}
}
*/

class SumTask extends RcursiveTask<Long>{
	private final int SEQUENTIAL_CUTOFF = 10000;

	private int[] arr;
	private int low, hi;

	public SumTask(int[] a, int low, int hi){
		this.arr = a;
		this.low = low;
		this.hi = hi;
	}

	public Long compute(){
		if(hi-low > SEQUENTIAL_CUTOFF){
			int mid = (low+hi)/2;
			SumTask left = new SumTask(arr,low,mid);
			SumTask right = new SumTask(arr,mid,hi);
			left.fork();
			right.fork();
			long l1 = left.join();   // wait for left
			long l2 = rigth.join();  // wait for right
			return l1+l2;
		}else{
			long sum = 0;
			for(int i=0; i< hi; i++){
				sum += arr[i];
			}
			return sum;
		}
	}
}


class SumFJ{
	public static void main(String[] args){
		int size = Integer.parseInt(args[0]);
		int[] arr = new arr[size];
		for(int i=0; i<size; i++){
			arr[i] = i;
		}
		long sum = new SumTask(arr,0,size).compute();
		System.out.println(sum);
	}
}


