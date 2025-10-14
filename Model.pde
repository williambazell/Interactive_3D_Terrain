// Model class holds all the information necessary for working with an elevation map.  This class is application

public class MapModel {
  private ElevationMap map;
  private ArrayList<PVector> trailPath;
  private ArrayList<PVector> waypoints;
  boolean hovering = false;
  PVector hoverLocation = new PVector(-1, -1);

  public MapModel(String filePath) {
    PImage heightMap = loadImage(filePath);
    map = new ElevationMap(heightMap, 0.0, 1.0);
    trailPath = new ArrayList<PVector>();
    waypoints = new ArrayList<PVector>();
  }
  // Add point on trail
  public void addTrailPoint(int x, int y) {
    trailPath.add(new PVector(x, y));
  }
  
  public ArrayList<PVector> getTrailPath() {
    return trailPath;
  }
  public void setTrailPath(ArrayList<PVector> path) {
    this.trailPath = path;
  }
  
  public ElevationMap getMap() {
    return map;
  }

  public ArrayList<PVector> getWaypoints() {
    return waypoints;
  }
  // Public way to add waypoints directly to model
  public void addWaypoint(PVector point) {
    waypoints.add(point);
  }
  // Public way to reassign the entire array of waypoints
  public void setWaypoints(ArrayList<PVector> waypoints) {
    this.waypoints = waypoints;
  }

  public PVector getHoverBar() {
    return this.hoverLocation;
  }
  public void setHoverBar(PVector location) {
    this.hoverLocation = location;
  }
  // Get status of hover bar (true for it should appear)
  public boolean getHovering() {
    return this.hovering;
  }
  public void setHovering(boolean state) {
    this.hovering = state;
  }
};


// Defines an elevation map for working with terrain
public class ElevationMap {
  private PImage heightMap;
  private PImage colorImage;
  private float low;
  private float high;
  private int[] eleHistogram;
  private int bins;

  // The heightmap image defines the width and height and the low and high allows the user to specify the elevation range.
  // The elevation map also holds a color image that can be edited with getColor(x,y) and setColor(x,y,c)
  public ElevationMap(PImage heightMap, float low, float high) {
    this.heightMap = heightMap;
    this.low = low;
    this.high = high;
    colorImage = new PImage(heightMap.width, heightMap.height);
    colorImage.copy(heightMap, 0, 0, heightMap.width, heightMap.height, 0, 0, heightMap.width, heightMap.height);
    heightMap.loadPixels();
    colorImage.loadPixels();
    // Calculate histogram
    this.bins = 50;
    eleHistogram = calculateHistogram(bins);
  }
  // Used for hover bar; get's the index on histogram where hoverbar should appear
  public int getBucketIndex(PVector point) {
    float binSize = (high - low) / this.bins;
    int bin = (int)((getElevation((int)point.x, (int)point.y) - low) / binSize);
    return constrain(bin, 0, bins - 1);
  }

  public int getWidth() {
    return heightMap.width;
  }

  public int getHeight() {
    return heightMap.height;
  }

  public float getElevation(int x, int y) {
    float normalizedElevation = 1.0*red(heightMap.pixels[x + y*heightMap.width])/255.0;
    return lerp(low, high, normalizedElevation);
  }
  // Get the color image for drawing and editing purposes
  public PImage getColorImage() {
    return colorImage;
  }
  // Get the color at a point in the map
  public color getColor(int x, int y) {
    return colorImage.pixels[x + y*heightMap.width];
  }

  public int[] getHistogram() {
    return eleHistogram;
  }
  // Sets the color at a point in the map
  public void setColor(int x, int y, color c) {
    colorImage.pixels[x + y*heightMap.width] = c;
  }

  // Calculate histogram based on number of bins
  public int[] calculateHistogram(int numBins) {
    int[] histogram = new int[numBins];
    float binSize = (high - low) / numBins;
    for (int i = 0; i < numBins; i++) {
      histogram[i] = 0;
    }
    // Calculate histogram
    for (int i = 0; i < heightMap.width; i++) {
      for (int j = 0; j < heightMap.height; j++) {
        float elevation = getElevation(i, j);
        // Find appropriate bin for map point's location
        int bin = (int)((elevation - low) / binSize);
        bin = constrain(bin, 0, numBins - 1);
        histogram[bin]++;
      }
    }
    return histogram;
  }
}
