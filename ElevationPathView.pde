import processing.core.PVector;

public class ElevationPathView extends View {
    private MapModel model;
    // List of map coordinates and their cooresponding screen coordinates
    ArrayList<CoordinateMapping> mappings = new ArrayList<>();
    public ElevationPathView(MapModel model, int x, int y, int w, int h) {
        super(x, y, w, h);
        this.model = model;
        mappings = new ArrayList<CoordinateMapping>();
    }
    public void drawView() {
        // Draw background and label
        fill(0);
        rect(x, y, w, h);
        fill(255);
        text("Elevation Path View", x + 10, y + 20);
        // Draw legend
        PImage img = loadImage("legend.jpg");
        image(img, x+20, y+40, 140, 200);
        // Draw path and waypoints
        ArrayList<PVector> trailPath = model.getTrailPath();
        ArrayList<PVector> waypoints = model.getWaypoints();
        mappings.clear();
        // Only draw path if it has been drawn
        if(!trailPath.isEmpty()){
          // Instantiate bounds for elevation path
          float drawWidth = w * 0.6f;
          float drawHeight = h * 0.6f;
          float xOffset = 180;
          float yOffset = y + h * 0.1f; 
          float maxDistance = 0;
          float maxElevation = Float.MIN_VALUE;
          float minElevation = Float.MAX_VALUE;
          float totalDistance = 0;
          PVector prevPoint = trailPath.get(0);
          float elevation = model.getMap().getElevation((int)prevPoint.x, (int)prevPoint.y);
          minElevation = elevation;
          maxElevation = elevation;
          // Calculate elevation path
          for(int i = 1; i < trailPath.size(); i++){
              PVector currentPoint = trailPath.get(i);
              totalDistance += PVector.dist(prevPoint, currentPoint);
              elevation = model.getMap().getElevation((int)currentPoint.x, (int)currentPoint.y);
              if (elevation < minElevation) minElevation = elevation;
              if (elevation > maxElevation) maxElevation = elevation;
              prevPoint = currentPoint;
          }
          maxDistance = totalDistance;
          // Draw elevation path
          pushStyle();
          stroke(255, 0, 0);
          strokeWeight(3);
          noFill();
          beginShape();
          totalDistance = 0;
          prevPoint = trailPath.get(0);
          for(int i = 0; i < trailPath.size(); i++){
              PVector point = trailPath.get(i);
              if(i > 0){
                 totalDistance += PVector.dist(prevPoint, point);
              }
              elevation = model.getMap().getElevation((int)point.x, (int)point.y);
              float xCoord = map(totalDistance, 0, maxDistance, xOffset, xOffset + drawWidth);
              float yCoord = map(elevation, minElevation, maxElevation, yOffset + drawHeight, yOffset);
              vertex(xCoord, yCoord);
              mappings.add(new CoordinateMapping(point, xCoord, yCoord));
              prevPoint = point;
          }
          endShape();
          // Draw waypoints
          noStroke();
          fill(0, 0, 255, 255);
          totalDistance = 0;
          prevPoint = trailPath.get(0);
          for(int i = 0; i < trailPath.size(); i++){
            PVector point = trailPath.get(i);
              if(i > 0){
                  totalDistance += PVector.dist(prevPoint, point);
              }
              elevation = model.getMap().getElevation((int)point.x, (int)point.y);
              float xCoord = map(totalDistance, 0, maxDistance, xOffset, xOffset + drawWidth);
              float yCoord = map(elevation, minElevation, maxElevation, yOffset + drawHeight, yOffset);
              // Only draw waypoints if their map position is equal to point on map
              for(PVector waypoint : waypoints){
                if(abs(waypoint.x - point.x) == 0 && abs(waypoint.y - point.y) == 0){
                  ellipse(xCoord, yCoord, 6, 6);
                }
              }
              prevPoint = point;
          }
          // Update hover bar status if mouse is inside view
          if(isInside(mouseX, mouseY)){
            updateHoverBar(mouseX, mouseY, mappings);
          }
          fill(255, 165,0, 230);
          noStroke();
          // Draw hover bar if status is set to true
          if(model.getHovering()){
              PVector location = model.getHoverBar();
              // Find mapping on elevation map where hover bar should be drawn
              for(CoordinateMapping coordinate : mappings){
                if(location.x == coordinate.originalPoint.x && location.y == coordinate.originalPoint.y){
                  rectMode(CENTER);
                  rect(coordinate.screenX, coordinate.screenY, 8, 24);
                  break;
               }
            }
          }
         popStyle();
         pushStyle();
        // Draw labels on chart
        String distanceText = String.format("Distance: %.2f m", maxDistance);
        text(distanceText, xOffset + drawWidth/2 - 40, yOffset + drawHeight + 50);
        String maxElevationText = String.format("Max Elev: %.2f m", (maxElevation*100)+2300);
        text(maxElevationText, xOffset + drawWidth - textWidth(maxElevationText) + 200, yOffset);
        String minElevationText = String.format("Min Elev: %.2f m", (minElevation*100)+2300);
        text(minElevationText, xOffset + drawWidth - textWidth(minElevationText) + 200, yOffset + drawHeight + 30);
        // Draw lines for label visualization
        stroke(255);
        strokeWeight(2);
        line(xOffset, yOffset + drawHeight + 20, xOffset + drawWidth ,yOffset + drawHeight + 20);
        line(xOffset, yOffset + drawHeight + 15, xOffset,yOffset + drawHeight + 25);
        line(xOffset + drawWidth, yOffset + drawHeight + 15, xOffset + drawWidth,yOffset + drawHeight + 25);
        line(xOffset + drawWidth - textWidth(minElevationText) + 280, yOffset + drawHeight + 10, xOffset + drawWidth - textWidth(minElevationText) + 280,yOffset + 10);
        line(xOffset + drawWidth - textWidth(minElevationText) + 275, yOffset + 15, xOffset + drawWidth - textWidth(minElevationText) + 280,yOffset + 10);
        line(xOffset + drawWidth - textWidth(minElevationText) + 285, yOffset + 15, xOffset + drawWidth - textWidth(minElevationText) + 280,yOffset + 10);
        popStyle();
      }
  }
  public void mousePressed() {
    float clickThreshold = 5;
    CoordinateMapping closestMapping = null;
    float closestDistance = Float.MAX_VALUE;
    // Find the closest mapping to the mouse click
    for(CoordinateMapping mapping : mappings){
        PVector mouseDistance = new PVector(mouseX, mouseY);
        PVector mappingDistance = new PVector(mapping.screenX, mapping.screenY);
        float distance = PVector.dist(mouseDistance, mappingDistance);
        if(distance < closestDistance){
            closestDistance = distance;
            closestMapping = mapping;
        }
    }
    // Update waypoint if it's under threshold
    if(closestMapping != null && closestDistance <= clickThreshold){
        PVector originalPoint = closestMapping.originalPoint;
        boolean waypointExists = model.getWaypoints().contains(originalPoint);
        ArrayList<PVector> waypoints = model.getWaypoints();
        // Remove waypoint if mouse was clicked on it
        if(waypointExists){
          // Find waypoint to remove
          for (int i = 0; i < waypoints.size(); i++) {
            PVector waypoint = waypoints.get(i);
            if(waypoint.x == originalPoint.x && waypoint.y == originalPoint.y){
                waypoints.remove(i);
                model.setWaypoints(waypoints);
                break;
            }
          }
        } else{model.addWaypoint(originalPoint);}
    }
  }
  // Helper function to update status of hover bar based on if it's close to map
  void updateHoverBar(int x, int y, ArrayList<CoordinateMapping> coordinates) {
        float minDist = Float.MAX_VALUE;
        PVector closestPoint = new PVector();
        int threshold = 5;
        // Iterate through trail path and see if mouse is close to any points
        for(CoordinateMapping coordinate : coordinates){
            PVector screenCoord = new PVector(coordinate.screenX, coordinate.screenY);
            float dist = PVector.dist(new PVector(x, y), screenCoord);
            if(dist < minDist && dist < threshold){
                minDist = dist;
                closestPoint = coordinate.originalPoint;
            }
        }
        // Update hover bar status and location if it's close to a point
        // Otherwise set its status to false
        if(closestPoint.x > 0 && closestPoint.y > 0 ){
          model.setHovering(true);
          model.setHoverBar(closestPoint);
        } else{
          model.setHovering(false);
          model.setHoverBar(new PVector(-1,-1));
        }
   }
}

// Class that stores map point and screen points for mapping waypoints
class CoordinateMapping {
    PVector originalPoint;
    float screenX;
    float screenY;
    CoordinateMapping(PVector originalPoint, float screenX, float screenY) {
        this.originalPoint = originalPoint;
        this.screenX = screenX;
        this.screenY = screenY;
    }
}

// Function to get screen coordinates from map coordiantes for mapping elevation onto view
PVector findOriginalCoordinates(float screenX, float screenY, ArrayList<CoordinateMapping>mappings) {
    CoordinateMapping closest = null;
    float closestDistance = Float.MAX_VALUE;
    // Iterate through mappings and find closest point on map within threshold click
    for(CoordinateMapping mapping : mappings){
        float distance = dist(screenX, screenY, mapping.screenX, mapping.screenY);
        if(distance < closestDistance){
            closestDistance = distance;
            closest = mapping;
        }
    }
    if(closest != null){
      return closest.originalPoint; 
    }
    return null;
}
