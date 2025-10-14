//  Application contains a model, a view, and a controller.
// - The model is a particle simulation that is independent of
//   graphics and user interaction
// - The view simply draws the model
// - The controller communicates between model and view

public class Application {
  
  private MapModel model;
  
  private MapView mapView;
  private Spatial3DView spatialView;
  private ElevationPathView elevationPathView;
  private HistogramView histogramView;
  
  private Controller controller;
  
  public Application() {
    // Create the model and set the height map we are interested in working with
    // Uncomment specific model to run in application
     model = new MapModel("colored_ashville.jpg");
    //model = new MapModel("minneapolis.jpg");
    //model = new MapModel("umn.jpg");
    //model = new MapModel("flower.jpg");
    //model = new MapModel("sunflowers.png");
   
    // Create views
    mapView = new MapView(model,0,0, width/2-1,(int)(0.65*height));
    spatialView = new Spatial3DView(model, width/2+1,0, width/2,(int)(0.65*height));
    elevationPathView = new ElevationPathView(model, 0,(int)(0.65*height)+2, (int)(width*0.65),(int)(0.35*height)-2);
    histogramView = new HistogramView(model, "colormap.png", (int)(width*0.65+3),(int)(0.65*height)+2, (int)(width*0.35-3),(int)(0.35*height)-2);
    
    // Create controller, which will update model and query views
    controller = new Controller(model, mapView, spatialView, elevationPathView, histogramView);
  }
  
  public void update(float dt) {
    controller.update(dt);
  }
  
  public void draw() {
    background(100, 100, 100);
    ellipseMode(RADIUS);
    mapView.draw();
    spatialView.draw();
    elevationPathView.draw();
    histogramView.draw();
  }
  
  public Controller getController() {
    return controller;
  }  
};
