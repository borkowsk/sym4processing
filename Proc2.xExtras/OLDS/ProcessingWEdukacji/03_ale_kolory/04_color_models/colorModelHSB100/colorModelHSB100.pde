//Model kolorów HSB (hue, saturation, brightness) alias
// HSL (hue, saturation, lightness) or HSV (hue, saturation, value)
// https://en.wikipedia.org/wiki/HSL_and_HSV 
// https://pl.wikipedia.org/wiki/HSL
noStroke();

colorMode(HSB, 100);//100 - default size of Processing window
for (int i = 0; i < 100; i++) {
  for (int j = 0; j < 100; j++) {
    stroke(i, j, 100);
    point(i, j);
  }
}

//http://processingwedukacji.blogspot.com
