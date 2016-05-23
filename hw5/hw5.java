/* Name: Baixiao Huang

   UID: 504313981

   Others With Whom I Discussed Things: Li Wei Tseng

   Other Resources I Consulted:
   
*/

import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.IntStream;
import static java.lang.Math.toIntExact;

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

    // public PPMImage mirrorImage3(){
    // 	RGB[] newImg = pixels.clone();
    // 	for (int i=0; i<height; i++) {
    // 		int j = i*width;
    // 		int k = (i+1)*width-1;
    // 		while(j<k){
    // 			RGB tmp = newImg[j];
    // 			newImg[j] = newImg[k];
    // 			newImg[k] = tmp;
    // 			j = j + 1;
    // 			k = k - 1;
    // 		}
    // 	}
    // 	return new PPMImage(width, height, maxColorVal, newImg);
    // }

	// implement using Java 8 Streams
    public PPMImage mirrorImage2() {
    	RGB[] newPixels = pixels.clone();
		RGB[] newImg = IntStream.range(0,newPixels.length)
				 .parallel()
				 .map(i->width*(i/width+1)-i%width-1)
				 .mapToObj(i->newPixels[i])
				 .toArray(RGB[]::new);
		return	new PPMImage(width, height, maxColorVal, newImg);
    }

	// implement using Java's Fork/Join library
    public PPMImage gaussianBlur(int radius, double sigma) {
    	double[][] kernel = Gaussian.gaussianFilter(radius, sigma);
    	RGB[] newImg = new RGB[pixels.length];
    	for (int i=0; i<pixels.length; i++) {
    		newImg[i] = new RGB(0,0,0);
    	}
    	(new GaussianBlurTask(pixels, newImg, width, height, 0, pixels.length, 10, kernel)).compute();
    	return new PPMImage(width, height, maxColorVal, newImg);
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


class GaussianBlurTask extends RecursiveAction{
	private RGB[] pixels;
	private RGB[] newPixels;
	private int width;
	private int height;
	private int lo;
	private int hi;
	private int SEQ_THRSHLD;
	private double[][] kernel;

	public GaussianBlurTask(RGB[] arr, RGB[] newArr, int wid, int hght, int lo, int hi, int thres, double[][] krnl){
		pixels = arr;
		newPixels = newArr;
		width = wid;
		height = hght;
		this.lo = lo;
		this.hi = hi;
		SEQ_THRSHLD = thres;
		kernel = krnl;
	}

	public void compute(){
		//divide the height
		if(hi-lo > width){
			int midHeight = (hi-lo)/width/2;
			int mid = lo + midHeight*width;
			invokeAll(new GaussianBlurTask(pixels, newPixels,width,height,lo,mid,SEQ_THRSHLD,kernel),
				      new GaussianBlurTask(pixels, newPixels,width,height,mid,hi,SEQ_THRSHLD,kernel));
		}else if(hi-lo>SEQ_THRSHLD){  // divide the width
			int mid = (hi+lo)/2;
			invokeAll(new GaussianBlurTask(pixels, newPixels, width, height, lo, mid, SEQ_THRSHLD,kernel),
					  new GaussianBlurTask(pixels, newPixels, width, height, mid, hi, SEQ_THRSHLD, kernel));
		}else{
			for (int i=lo; i<hi; i++) {
				int radius = kernel.length/2;
				for (int j=0; j<kernel.length; j++) {
					for(int k=0; k<kernel.length; k++){
						int pixelX = i%width;    // center
						int pixelY = i/width;    // center
						int x = pixelX - radius + k; 
						x = x < 0 ? 0 : x < width ? x : width - 1;
						int y = pixelY - radius + j;
						y = y < 0 ? 0 : y < height ? y : height - 1;
						// if(newPixels[pixelY*width + pixelX]==null) newPixels[pixelY*width + pixelX] = new RGB(0,0,0);
						newPixels[pixelY*width + pixelX].R += toIntExact(Math.round(pixels[y*width + x].R*kernel[j][k]));
						newPixels[pixelY*width + pixelX].G += toIntExact(Math.round(pixels[y*width + x].G*kernel[j][k]));
						newPixels[pixelY*width + pixelX].B += toIntExact(Math.round(pixels[y*width + x].B*kernel[j][k]));
					}
				}
			}
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
    	original.gaussianBlur(20,5).toFile("gaussianBlur.ppm");
    }
}

