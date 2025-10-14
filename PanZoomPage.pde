public class PanZoomPage { 
  
  public PanZoomPage(int x, int y, int w, int h) {
    scale = 1.0;
    translateX = 0;
    translateY = 0;
    lastMouseX = 0;
    lastMouseY = 0;
    offsetX = x;
    offsetY = y;
    pageWidth = w;
    pageHeight = h;
  
    fitPageOnScreen(); 
  }
  
  
  float pageXtoScreenX(float pageX) {
    return pageX * scale + translateX; 
  }
  
  float pageYtoScreenY(float pageY) {
    return pageY * scale + translateY; 
  }
  
  float pageLengthToScreenLength(float l) {
    return l * scale; 
  }
  
  
  float screenXtoPageX(float screenX) {
    return (screenX - translateX) / scale;
  }
  
  float screenYtoPageY(float screenY) {
    return (screenY - translateY) / scale;
  }
  
  float screenLengthToPageLength(float l) {
    return l / scale; 
  }
  
  void fitPageOnScreen() {
    if (pageWidth >= pageHeight) {
      scale = pageHeight;
      translateY = offsetY;
      translateX = offsetX + (pageWidth - pageHeight) / 2.0;
    }
    else {
      scale = pageWidth;
      translateX = offsetX;
      translateY = offsetY + (pageHeight - pageWidth) / 2.0;
    }
  }

  void mousePressed() {
    //if (mouseButton == LEFT) {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    //}
  }
  
  void mouseDragged() {
    //if (mouseButton == LEFT) {
      int deltaX = mouseX - lastMouseX;
      int deltaY = mouseY - lastMouseY;
      translateX += deltaX;
      translateY += deltaY;
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    //}
  }

  void mouseWheel(MouseEvent e)
  {
    float scaleDelta = 1.0;
    if (e.getCount() > 0) {
      scaleDelta = 1.02;
    } 
    else if (e.getCount() < 0) {
      scaleDelta = 0.98;
    }
  
    if (scaleDelta != 1.0) {
      translateX -= mouseX;
      translateY -= mouseY;
      scale *= scaleDelta;
      translateX *= scaleDelta;
      translateY *= scaleDelta;
      translateX += mouseX;
      translateY += mouseY;
    }
  }
  
  float scale = 1.0;
  float translateX = 0.0;
  float translateY = 0.0;
  int lastMouseX = 0;
  int lastMouseY = 0;
  int offsetX;
  int offsetY;
  int pageHeight;
  int pageWidth;
}
