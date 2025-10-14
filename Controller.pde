// Controller can update the model, query the view, and modify view display parameters

public class Controller {
  private MapModel model;
  private MapView mapView;
  private Spatial3DView spatialView;
  private ElevationPathView elevationPathView;
  private HistogramView histogramView;
  
  Controller(MapModel model, MapView mapView, Spatial3DView spatialView, ElevationPathView elevationPathView, HistogramView histogramView) {
    this.model = model;
    this.mapView = mapView;
    this.spatialView = spatialView;
    this.elevationPathView = elevationPathView;
    this.histogramView = histogramView;
  }
  
  public void update(float dt) {
    spatialView.setRotation(frameCount/1000.0);
  }
  
  public void mousePressed() {
    //Execute logic for each view if mouse is pressed in view window
    if(mapView.isInside(mouseX, mouseY) && (mouseButton == CENTER || mouseButton == RIGHT)){
      mapView.panZoomPage.mousePressed();
    } else if(mapView.isInside(mouseX, mouseY) && mouseButton == LEFT){
      mapView.mousePressed();
    } else if(elevationPathView.isInside(mouseX, mouseY) && mouseButton == LEFT){
      elevationPathView.mousePressed();
    }
  }
  
  public void mouseReleased() {
    //Execute logic for each view if mouse is released in view window (for dragging)
    if(mapView.isInside(mouseX, mouseY) && mouseButton == LEFT){
      mapView.mouseReleased();
    }
  }
  
  public void mouseDragged() {  
    //Execute logic for each view if mouse is released in view window (for dragging)
    if(mapView.isInside(mouseX, mouseY) && (mouseButton == CENTER || mouseButton == RIGHT)){
      mapView.panZoomPage.mouseDragged();
    } else if(mapView.isInside(mouseX, mouseY) && mouseButton == LEFT){
      mapView.mouseDragged();
    }
  }
  
  public void mouseMoved() {
    if (mapView.isInside(mouseX, mouseY)) {
      cursor(CROSS);
    }
    else {
      cursor(ARROW);
    }
  }
  
  public void mouseWheel(MouseEvent event) {
    if (mapView.isInside(mouseX, mouseY)) {
      mapView.panZoomPage.mouseWheel(event);
    }
    
    if (spatialView.isInside(mouseX, mouseY)) {
      spatialView.setZoom(spatialView.getZoom() + event.getCount()*0.1);
    }
  }
}
