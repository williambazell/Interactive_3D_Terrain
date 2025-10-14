//Draws 3D spatial view of map

public class Spatial3DView extends View {
  private MapModel model;
  int scl = 5;
  int cols, rows;
  int meshSize;
  PGraphics scene;
  float aspect;
  float rotation = 0;
  float zoom = 1.0;
  
  public Spatial3DView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;

    // Use width and height to create height mesh.
    meshSize = min(w,h);
    cols = meshSize / scl;
    rows = meshSize / scl;
    aspect = 1.0*model.getMap().getWidth()/model.getMap().getHeight();
    
    scene = createGraphics(w, h, P3D);
  }
  
  public void drawView() {
    // Begin drawing the 3D texture
    scene.beginDraw();
    scene.background(0);
    scene.noStroke();
    scene.fill(0,0,0);
    scene.rect(0,0, w, h);
    scene.fill(255);
    scene.lights();
    
    // Translate the mesh to a 3D view
    scene.translate(0,0,250);
    scene.translate(w/2, h/2); 
    scene.rotateX(PI/3);
    scene.rotateZ(rotation);
    scene.scale(0.4*zoom);
    scene.translate(-meshSize*aspect/2, -meshSize/2);   
        
    // Draw the mesh as a set of Triangle Strips
    for (int y = 0; y < rows-1; y++) {
      scene.beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        int yLookup = (int)(1.0*y/(rows-1)*model.getMap().getHeight());
        int xLookup = (int)(1.0*x/(cols)*model.getMap().getWidth());
        int yp1Lookup = (int)(1.0*(y+1)/(rows-1)*model.getMap().getHeight());
        
        // Draw the plane and raise each point in the z direction based on the height
        if (xLookup < model.getMap().getWidth() && yLookup < model.getMap().getHeight() && yp1Lookup < model.getMap().getHeight()) {
          scene.fill(model.getMap().getColor(xLookup, yLookup));
          scene.vertex(x*scl*aspect, y*scl, model.getMap().getElevation(xLookup, yLookup)*255/3);
          scene.fill(model.getMap().getColor(xLookup, yp1Lookup));
          scene.vertex(x*scl*aspect, (y+1)*scl, model.getMap().getElevation(xLookup, yp1Lookup)*255/3);
        }
      }
      scene.endShape();
    }
    
    // Draw trail on path if it exists
    scene.strokeWeight(13);
    scene.stroke(255, 0, 0);
    ArrayList<PVector> trailPath = model.getTrailPath();
    if(!trailPath.isEmpty()){
        for(int i = 0; i < trailPath.size() - 1; i++){
            //Convert to normalized coordinates
            PVector start = trailPath.get(i);
            PVector end = trailPath.get(i + 1);
            float normX1 = start.x / model.getMap().getWidth();
            float normY1 = start.y / model.getMap().getHeight();
            float normX2 = end.x / model.getMap().getWidth();
            float normY2 = end.y / model.getMap().getHeight();
            //Draw line between points
            drawLineOnMap(scene, normX1, normY1, normX2, normY2);
        }
    }
    // Draw waypoints on map if they exist
    ArrayList<PVector> waypoints = model.getWaypoints();
    scene.stroke(0,0,255);
    scene.fill(0, 0, 255);
    for(PVector waypoint : waypoints){
        float normX = waypoint.x / model.getMap().getWidth();
        float normY = waypoint.y / model.getMap().getHeight();
        drawSphereOnMap(scene, normX, normY, 4);
    }
    // Draw hover bar if it exists
    if(model.getHovering()){
        PVector hoverLoc = model.getHoverBar();
        if(hoverLoc.x != 0 && hoverLoc.y != 0){
          float normX = hoverLoc.x / model.getMap().getWidth();
          float normY = hoverLoc.y / model.getMap().getHeight();
          scene.fill(255, 165, 0);
          scene.noStroke();
          drawBoxOnMap(scene, normX, normY, 10);
        }
    }

    scene.endDraw();
    // Draw the scene texture.
    pushMatrix();
    translate(x, y);
    image(scene, 0, 0);
    // Draw legend over 3D View
    PImage img = loadImage("legend.jpg");
    image(img, 0, 0, w-675, h-350);
    popMatrix();
  }

  // Draws a line above the mesh using the height.
  void drawLineOnMap(PGraphics scene, float normX1, float normY1, float normX2, float normY2) {
    int w = model.getMap().getWidth();
    int h = model.getMap().getHeight();
    int x1 = (int)(normX1*w);
    int y1 = (int)(normY1*h);
    int x2 = (int)(normX2*w);
    int y2 = (int)(normY2*h);
    int z1 = (int)(model.getMap().getElevation(x1, y1)*255/3) + 5;
    int z2 = (int)(model.getMap().getElevation(x2, y2)*255/3) + 5;
    scene.line(normX1*meshSize*aspect, normY1*meshSize, z1, normX2*meshSize*aspect, normY2*meshSize, z2);
  }
  
  // Draws a sphere above the mesh using the height.
  void drawSphereOnMap(PGraphics scene, float normX, float normY, int size) {
    scene.pushMatrix();
    translateShapeOnMap(scene, normX, normY, size);
    scene.sphere(size);
    scene.popMatrix();
  }
  
  // Draws a box above the mesh using the height.
  void drawBoxOnMap(PGraphics scene, float normX, float normY, int size) {
    scene.pushMatrix();
    translateShapeOnMap(scene, normX, normY, size);
    scene.box(6, 6, 12);
    scene.popMatrix();
  }
  
  // Translates a shape above the mesh using the height.
  void translateShapeOnMap(PGraphics scene, float normX, float normY, int size) {
    int w = model.getMap().getWidth();
    int h = model.getMap().getHeight();
    int x = (int)(normX*w);
    int y = (int)(normY*h);
    int z = (int)(model.getMap().getElevation(x, y)*255/3) + 5+size/2;
    scene.translate(normX*meshSize*aspect, normY*meshSize, z);
  }
  
  void setRotation(float rot) {
    rotation = rot;
  }
  
  public float getZoom() {
    return zoom;
  }
  
  void setZoom(float zoom) {
    this.zoom = zoom;
  }
};
