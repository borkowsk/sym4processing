// https://en.wikipedia.org/wiki/HSL_and_HSV 
// https://pl.wikipedia.org/wiki/HSL
size(256,256);
noStroke();

colorMode(HSB);

for (int i = 0; i < 256; i++) {
  for (int j = 0; j < 256; j++) {
    stroke(i, j, 256);
    point(i, j);
  }
}

//http://processingwedukacji.blogspot.com
