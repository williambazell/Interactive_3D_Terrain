Application application = null;
int time = 0;

void setup() {
  size(1600,800,P3D);
  application = new Application();
  time = millis();
}

// Render graphics application
void draw() {
  int oldTime = time;
  time = millis();
  float dt = 1.0*(time-oldTime)/1000.0;
  application.update(dt);
  application.draw();
}

//---Events are handled by the controller---

// Call the controller's event method
void mousePressed() {
  application.getController().mousePressed();
}

// Call the controller's event method
void mouseReleased() {
  application.getController().mouseReleased();
}

// Call the controller's event method
void mouseDragged() {
  application.getController().mouseDragged();
}

// Call the controller's event method
public void mouseMoved() {
  application.getController().mouseMoved();
}

// Call the controller's event method
void mouseWheel(MouseEvent event) {
  application.getController().mouseWheel(event);
}
