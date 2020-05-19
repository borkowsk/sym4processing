// Sierpinskis Triangle
// https://stackoverflow.com/questions/42964699/having-trouble-drawing-sierpinskis-triangle-in-processing
//////////////////////////////////////////////////////////////////////////////////

ArrayList<PVector> initPoints;
int defLevel=-1;
int level=defLevel;

void setup() {
  size(400, 400);
  noFill();
  initPoints = new ArrayList<PVector>();
  initPoints.add(new PVector(width/2, height/4));
  initPoints.add(new PVector(width/4, 3 * height/4));
  initPoints.add(new PVector(3 * width/4, 3 * height/4));
}

void draw() {
  triangle(initPoints.get(0).x, initPoints.get(0).y, initPoints.get(1).x, initPoints.get(1).y, initPoints.get(2).x, initPoints.get(2).y);
  for (int i = 0; i < 3; i++) {
    level = defLevel;
    drawTri(i, initPoints, level);
  }
}

PVector findMid(PVector a, PVector b) {
  int midX = floor((a.x + b.x)/2);
  int midY = floor((a.y + b.y)/2);

  return new PVector(midX, midY);
}

void drawTri(int vertex, ArrayList<PVector> basePoints, int layer) {
  level = layer + 1;
  ArrayList<PVector> points = new ArrayList<PVector>();
  points.add(basePoints.get(vertex % 3));
  points.add(findMid(basePoints.get(vertex % 3), basePoints.get((vertex + 1) % 3)));
  points.add(findMid(basePoints.get(vertex % 3), basePoints.get((vertex + 2) % 3)));
  triangle(points.get(0).x, points.get(0).y, points.get(1).x, points.get(1).y, points.get(2).x, points.get(2).y);
  if (level < 4) {
    for (int i = 0; i < 3; i++) {
      drawTri(i, points, level);
    }
  }
}
