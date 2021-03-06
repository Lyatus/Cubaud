class RenderThread extends Thread {
  private int id;
  private PImage buffer;
  RenderThread(int id) {
    this.id = id;
    this.buffer = createImage(width, height, ARGB);
    this.buffer.loadPixels(); // Allocate pixels array
  }
  public void run() {
    float w = 1/((float)width/2); // Map ahead, multiplications are faster than divisions
    float h = 1/((float)height/2);
    try {
      while (true) {
        startSem.acquire();
        for (int y=id; y<height; y+=threadCount)
          for (int x=0; x<width; x++) 
            buffer.pixels[y*width+x] = (0xFF000000|world.shade(camera.ray(x*w-1, -(y*h-1))));
        endSem.release();
      }
    }
    catch(InterruptedException ie) {
    }
  }
  public void blit() {
    buffer.updatePixels(); // Confirm changes made in the pixels array
    image(buffer, 0, 0);
  }
}

