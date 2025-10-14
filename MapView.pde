public class MapView extends View {
  private MapModel model;
  private float zoom = 1.0;
  public float translateX = 0.0;
  public float translateY = 0.0;
  private PanZoomPage panZoomPage;
  PImage img;
  float imgScale;
  float aspect;
  private ArrayList<PVector> mapPath;
  private ArrayList<PVector> mapWaypoints;
  private boolean isDrawing = false;
  private boolean dragStarted = false;
  private float waypointRadius = 2.25;
  private float proximityThreshold = 4;
  
  public MapView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
    img = model.getMap().getColorImage();
    panZoomPage = new PanZoomPage(x, y, w, h);
    panZoomPage.fitPageOnScreen();
    mapPath = new ArrayList<PVector>();
    mapWaypoints = new ArrayList<PVector>();
    
    
    if (img.width > img.height) {
      imgScale = 1.0/img.width;
    } else {
      imgScale = 1.0/img.height;
    }
  }
  
  public void drawView() {
    // Center the map
    float imageX = panZoomPage.pageXtoScreenX(0.5);
    float imageY = panZoomPage.pageYtoScreenY(0.5);
    
    // Draw the map using the panZoomPage
    pushMatrix();
    translate(imageX, imageY);
    scale(1.0*panZoomPage.pageLengthToScreenLength(1.0)*imgScale);
    translate(-img.width/2,-img.height/2);
    image(img, 0, 0);
     
    // Draw trail on the map
    pushStyle();
    stroke(255, 0, 0);
    strokeWeight(3);
    noFill();
    beginShape();
    for(PVector point : mapPath){
      vertex(point.x, point.y, 0);
    }
    endShape();
    popStyle();
    // Draw waypoints on the map
    pushStyle();
    fill(0, 0, 255);
    noStroke();
    for(PVector waypoint : mapWaypoints){
        ellipseMode(CENTER);
        ellipse(waypoint.x, waypoint.y, waypointRadius * 3, waypointRadius * 3);
    }
    popStyle();
    // Draw hoverbar and update model if mouse is close to path
    pushStyle();
    fill(255, 165,0, 230);
    noStroke();
    // Update hoverbar status if mouse in view
    if(isInside(mouseX, mouseY)){
      updateHoverBar(mouseX, mouseY, mapPath);
    }
    // Draw hover bar if it exists
    if(model.getHovering()){
      PVector location = model.getHoverBar();
      if(location.x != 0 && location.y != 0){
        rectMode(CENTER);
        rect(location.x, location.y, 5, 15);
      }
    }
    popStyle();
    popMatrix();
    
    // Show the cross hairs for querying the image
    pushStyle();
    stroke(200,0,0);
    line(mouseX,0, mouseX,h);
    line(0,mouseY, w,mouseY);
    fill(255,255,255);
    textSize(20);
    int imgX = screenXtoImageX(mouseX);
    int imgY = screenYtoImageY(mouseY);
    if (imgX >= 0 && imgX < img.width && imgY >= 0 && imgY < img.height) {
      text("" + imgX + ", " + imgY , mouseX+50, mouseY+50);
    }
    popStyle();
    //Draw legend image
    PImage img = loadImage("legend.jpg");
    image(img, 0, 0, 140, 200);
   
  }
    

  // Use the screen position to get the x value of the image
  public int screenXtoImageX(int screenX) {
    float x = panZoomPage.screenXtoPageX(screenX);
    return (int)((x-0.5 + img.width*imgScale/2)*img.width/(img.width*imgScale));
  }
  
  // Use the screen position to get the y value of the image
  public int screenYtoImageY(int screenY) {
    float y = panZoomPage.screenYtoPageY(screenY);
    return (int)((y-0.5 + img.height*imgScale/2)*img.height/(img.height*imgScale));
  }
  
  public void mousePressed() {
    dragStarted = false;
    // If mouse is pressed when not drawing, add waypoint
    if(!isDrawing && isMouseNearPath(mouseX, mouseY)){
            int mapX = screenXtoImageX(mouseX);
            int mapY = screenYtoImageY(mouseY);
            PVector mapPoint = pointOnPath(mapX, mapY);
            if(mapPoint != null){
              manageWaypoint(mapPoint);
            }
     }
  }

  public void mouseDragged(){
    // If mouse is starting to drag, clear previous path and waypoints
    if(!dragStarted){
      mapPath.clear();
      mapWaypoints.clear();
      model.setHovering(false);
      model.setHoverBar(new PVector(-1, -1));
      dragStarted = true;
      isDrawing = true; 
    }
    // If mouse is drawing path already, update point on map for every iteration of draw
    if(isDrawing){
      int mapX = screenXtoImageX(mouseX);
      int mapY = screenYtoImageY(mouseY);
      PVector mapPoint = new PVector(mapX, mapY);
      mapPath.add(mapPoint);
    }
  }

  public void mouseReleased() {
    isDrawing = false;
    dragStarted = false;
    model.setTrailPath(mapPath);
  }
  
  boolean isMouseNearPath(int mouseX, int mouseY) {
    for(PVector point : mapPath){
        if(PVector.dist(new PVector(screenXtoImageX(mouseX), screenYtoImageY(mouseY)), point) < proximityThreshold){
            return true;
         }
    }
    return false;
  }
  
  // Find closest point on path mouse is closest to
  PVector pointOnPath(int x, int y){
    for(PVector point : mapPath){
        if(PVector.dist(new PVector(x, y), point) < proximityThreshold){
            return point;
        }
    }
      return null;
  }
  
  // Add or delete waypoints
  private void manageWaypoint(PVector mapPoint){
      boolean foundWaypoint = false;
      for(int i = 0; i < mapWaypoints.size(); i++){
          PVector waypoint = mapWaypoints.get(i);
          // Delete waypoint if it's within click threshold
          if(PVector.dist(mapPoint, waypoint) < proximityThreshold){
              mapWaypoints.remove(i);
              foundWaypoint = true;
              break;
          }
      }
      // If waypoint doesn't exist already, then add it
      if(!foundWaypoint){
          mapWaypoints.add(mapPoint);
      }
      // Update waypoints in model
      model.setWaypoints(mapWaypoints);
  }
  // Update hover bar status
  void updateHoverBar(int x, int y, ArrayList<PVector> points) {
        float minDist = Float.MAX_VALUE;
        int closestIndex = -1;
        PVector closestPoint = new PVector();
        int threshold = 5;
        // Iterate through entire path to see if mouse is close to any of them
        for(int i = 0; i < points.size(); i++){
            PVector point = points.get(i);
            float mapX = screenXtoImageX(x);
            float mapY = screenYtoImageY(y);
            float dist = PVector.dist(new PVector(mapX, mapY), point);
            // Update closest point on map within threshold distance
            if(dist < minDist && dist < threshold){
                minDist = dist;
                closestPoint.set(point.x, point.y);
                closestIndex = i;
            }
        }
        // If mouse is close to point on path, update model's hover bar location
        if(closestIndex != -1){
          model.setHovering(true);
          model.setHoverBar(closestPoint);
        } else{
          model.setHovering(false);
          model.setHoverBar(new PVector(-1,-1));
        }
    }
};
