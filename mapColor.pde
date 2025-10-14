//Function to put color to grayscale elevation map; taken from ApplyColorMap
String mapColor(String imgName, String colorMapName){
  PImage img;
  PImage colorMap;
  img = loadImage(imgName);
  colorMap = loadImage(colorMapName);
  windowResize(img.width, img.height);
  img.loadPixels();
  colorMap.loadPixels();
  //Assign color based on elevation for each point on map
  for(int y = 0; y < img.height; y++){
    for(int x = 0; x < img.width; x++){
      int loc = x + y*img.width;
      float height = red(img.pixels[loc]);
      img.pixels[loc] = mapColor(colorMap, height/255);
    }
  }
  img.updatePixels();
  String colorImg = "colored_" + imgName;
  img.save(colorImg);
  return colorImg;
}

color mapColor(PImage map, float value) {
  float x = lerp(0, map.width-1, value);
  int loc = (int)(x + map.width);
  return map.pixels[loc];
}
