/* Name: Baixiao Huang

   UID: 504313981

   Others With Whom I Discussed Things: Li Wei Tseng

   Other Resources I Consulted:
   
*/

import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.IntStream;

// a marker for code that you need to implement
class ImplementMe extends RuntimeException {}

// an RGB triple
class RGB {
    public int R, G, B;

    RGB(int r, int g, int b) {
    	R = r;
		G = g;
		B = b;
    }

    public String toString() { return "(" + R + "," + G + "," + B + ")"; }

}


// an object representing a single PPM image
class PPMImage {
    protected int width, height, maxColorVal;
    protected RGB[] pixels;

    public PPMImage(int w, int h, int m, RGB[] p) {
		width = w;
		height = h;
		maxColorVal = m;
		pixels = p;
    }

    // parse a PPM image file named fname and produce a new PPMImage object
    public PPMImage(String fname) 
    	throws FileNotFoundException, IOException {
		FileInputStream is = new FileInputStream(fname);
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		br.readLine(); // read the P6
		String[] dims = br.readLine().split(" "); // read width and height
		int width = Integer.parseInt(dims[0]);
		int height = Integer.parseInt(dims[1]);
		int max = Integer.parseInt(br.readLine()); // read max color value
		br.close();

		is = new FileInputStream(fname);
	    // skip the first three lines
		int newlines = 0;
		while (newlines < 3) {
	    	int b = is.read();
	    	if (b == 10)
				newlines++;
		}

		int MASK = 0xff;
		int numpixels = width * height;
		byte[] bytes = new byte[numpixels * 3];
        is.read(bytes);
		RGB[] pixels = new RGB[numpixels];
		for (int i = 0; i < numpixels; i++) {
	    	int offset = i * 3;
	    	pixels[i] = new RGB(bytes[offset] & MASK, 
	    						bytes[offset+1] & MASK, 
	    						bytes[offset+2] & MASK);
		}
		is.close();

		this.width = width;
		this.height = height;
		this.maxColorVal = max;
		this.pixels = pixels;
    }

	// write a PPMImage object to a file named fname
    public void toFile(String fname) throws IOException {
		FileOutputStream os = new FileOutputStream(fname);

		String header = "P6\n" + width + " " + height + "\n" 
						+ maxColorVal + "\n";
		os.write(header.getBytes());

		int numpixels = width * height;
		byte[] bytes = new byte[numpixels * 3];
		int i = 0;
		for (RGB rgb : pixels) {
	    	bytes[i] = (byte) rgb.R;
	    	bytes[i+1] = (byte) rgb.G;
	    	bytes[i+2] = (byte) rgb.B;
	    	i += 3;
		}
		os.write(bytes);
		os.close();
    }

	// implement using Java 8 Streams
    public PPMImage negate() {
		RGB[] newImg = Arrays.stream(pixels).parallel().map(p->p = new RGB(maxColorVal-p.R,maxColorVal-p.G,maxColorVal-p.B)).toArray(s->new RGB[s]);
		return new PPMImage(width, height, maxColorVal, newImg);
    }

	// implement using Java 8 Streams
    public PPMImage greyscale() {
		RGB[] newImg = Arrays.stream(pixels).parallel().map(p-> {int a = Math.round(0.299f*p.R+0.587f*p.G+0.114f*p.B); return new RGB(a,a,a);}).toArray(s->new RGB[s]);
		return new PPMImage(width, height, maxColorVal, newImg);
    }    
    
	// implement using Java's Fork/Join library
    public PPMImage mirrorImage() {
    	RGB[] newImg = pixels.clone();
		(new MirrorTask(newImg,0, newImg.length, width, height)).compute();
		return new PPMImage(width,height,maxColorVal,newImg);
    }

	// implement using Java 8 Streams
    public PPMImage mirrorImage2() {
    	RGB[] newPixels = pixels.clone();
		RGB[] newImg = IntStream.range(0,newPixels.length)
				 .map(i->width*(i/width+1)-i%width-1)
				 .mapToObj(i->newPixels[i])
				 .toArray(RGB[]::new);
		return	new PPMImage(width, height, maxColorVal, newImg);
    }

	// implement using Java's Fork/Join library
    public PPMImage gaussianBlur(int radius, double sigma) {
		throw new ImplementMe();
    }

}

class MirrorTask extends RecursiveAction{
	private RGB[] pixels;
	private int width;
	private int hi,lo,height;

	public MirrorTask(RGB[] p, int lo, int hi, int width, int height){
		pixels = p;
		this.width = width;
		this.hi = hi;
		this.lo = lo;
		this.height = height;
	}
	public void compute(){
		if((hi-lo) <= width){
			int j = hi - 1;
			int i = lo;
			while(i<j) {
				RGB tmp = pixels[i];
				pixels[i] = pixels[j];
				pixels[j] = tmp;
				j = j - 1;
				i = i + 1;
			}
		}else{
			int half = height/2;
			int mid = lo + width*half;
			invokeAll(new MirrorTask(pixels,lo,mid,width, half), new MirrorTask(pixels,mid,hi,width,height - half));
		}
	}
}


// code for creating a Gaussian filter
class Gaussian {

    protected static double gaussian(int x, int mu, double sigma) {
		return Math.exp( -(Math.pow((x-mu)/sigma,2.0))/2.0 );
    }

    public static double[][] gaussianFilter(int radius, double sigma) {
		int length = 2 * radius + 1;
		double[] hkernel = new double[length];
		for(int i=0; i < length; i++)
	    	hkernel[i] = gaussian(i, radius, sigma);
		double[][] kernel2d = new double[length][length];
		double kernelsum = 0.0;
		for(int i=0; i < length; i++) {
	    	for(int j=0; j < length; j++) {
				double elem = hkernel[i] * hkernel[j];
				kernelsum += elem;
				kernel2d[i][j] = elem;
	    	}
		}
		for(int i=0; i < length; i++) {
	    	for(int j=0; j < length; j++)
				kernel2d[i][j] /= kernelsum;
		}
		return kernel2d;
    }
}

class Test {
    public static void main(String[] args) throws IOException, FileNotFoundException{
    	PPMImage original = new PPMImage("florence.ppm");
    	original.negate().toFile("negate.ppm");
    	original.greyscale().toFile("greyscale.ppm");
    	original.mirrorImage().toFile("mirrorImage.ppm");
    	original.mirrorImage2().toFile("mirrorImage2.ppm");
    }
}

