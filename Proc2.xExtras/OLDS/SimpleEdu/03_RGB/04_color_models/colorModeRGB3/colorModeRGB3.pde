// https://pl.wikipedia.org/wiki/RGB
noStroke();

colorMode(RGB, 100);
for (int i = 0; i < 100; i++) {
  for (int j = 0; j < 100; j++) {
    stroke(0, i, j);
    point(i, j);
  }
}

//http://processingwedukacji.blogspot.com
