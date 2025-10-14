import processing.core.PApplet;

public class HistogramView extends View {
  private MapModel model;
  private String colorMap;
  
  public HistogramView(MapModel model, String colorMap, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
    this.colorMap = colorMap;
  }
  
  public void drawView() {
    PImage colorMap = loadImage(this.colorMap);
    int[] histogram = model.getMap().getHistogram();
    // Draw background and labels
    fill(0); 
    noStroke();
    rect(x, y, w, h);
    pushStyle();
    fill(255); 
    text("Elevation Histogram", x + 40, y + 40);
    textSize(14);
    text("Low:", x+10, y+230);
    text("2300m", x+10, y+245);
    text("High:", x+510, y+230);
    text("2400m", x+510, y+245);
    popStyle();
    // Color map/histogram width bounds
    float colorMapWidth = w * 0.8f;
    float colorMapX = x + (w - colorMapWidth)/2;
    int colorMapHeight = 40;
    // Draw histogram
    pushStyle();
    stroke(255);
    noFill();
    // Create curve shape based on histogram bin locations
    beginShape();
    int max = max(histogram);
    for(int i = 0; i < histogram.length; i++){
      float xCoord = map(i, 0, histogram.length - 1, colorMapX, colorMapX + colorMapWidth);
      float yCoord = map(histogram[i], 0, max, y + h - colorMapHeight - 30, y + 60);
      vertex(xCoord, yCoord);
    }
    endShape();
    // Draw hoverbar if it exists
    if(model.getHovering() && model.getHoverBar().x > 0 && model.getHoverBar().y > 0){
      pushStyle();
      // Use coordinate mapping used for histogram to find hoverbar location
      int index = model.getMap().getBucketIndex(model.getHoverBar());
      float xCoord = map(index, 0, histogram.length - 1, colorMapX, colorMapX + colorMapWidth);
      float yCoord = map(histogram[index], 0, max, y + h - colorMapHeight - 30, y + 60);
      rectMode(CENTER);
      noStroke();
      fill(255, 165,0, 230);
      rect(xCoord, yCoord, 7, 16);
      popStyle(); 
    }
    popStyle();
    // Draw color map at bottom of histogram
    // Reverse color map since histogram goes lowest -> highest
    pushMatrix();
    scale(-1.0, 1.0);
    translate(-colorMapX*2 - colorMapWidth, 0);
    image(colorMap, colorMapX, y + h - colorMapHeight - 20, colorMapWidth, colorMapHeight);
    popMatrix();
  }
  
  // Find max for histogram bounds
  private int max(int[] values) {
    int maxValue = values[0];
    for(int value : values){
      if(value > maxValue){
        maxValue = value;
      }
    }
    return maxValue;
  }
}
