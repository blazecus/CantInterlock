import queasycam.*;
QueasyCam cam;
ArrayList<PVector[]> lines;
ArrayList<PVector> colors;
ArrayList<PVector> originalLengths;
float multiplier = 1.0;

void setup(){
  size(1920,1080, P3D);
  cam = new QueasyCam(this);
  lines = new ArrayList<PVector[]>();
  colors = new ArrayList<PVector>();
  originalLengths = new ArrayList<PVector>();
  for(int i = 0; i < 5; i++){
    add_new_chain(lines, colors, originalLengths);
  }
  
}

void add_new_chain(ArrayList<PVector[]> lines, ArrayList<PVector> colors, ArrayList<PVector> originalLengths){
  colors.add(new PVector(random(0,255), random(0,255), random(0, 255)));
  PVector[] points = {
    new PVector(random(-100,100), random(-100,100), random(-100, 100)), 
    new PVector(random(-100,100), random(-100,100), random(-100, 100)), 
    new PVector(random(-100,100), random(-100,100), random(-100, 100))
  };
  lines.add(points);
  originalLengths.add(new PVector(points[0].sub(points[1]).mag(), points[2].sub(points[1]).mag()));
}

PVector[] produce_new_vectors(PVector[] l, float multiplier, PVector originalLengths){
  PVector[] temp = {PVector.mult(l[0], multiplier), PVector.mult(l[1], multiplier), PVector.mult(l[2], multiplier)};
  PVector l1 = temp[0].sub(temp[1]);
  temp[0] = l[0].sub(l1.mult( 1 - (float)(originalLengths.x / l1.mag())));
  PVector l2 = temp[2].sub(temp[1]);
  temp[2] = l[2].sub(l2.mult( 1 - (float)(originalLengths.y / l2.mag())));
  print((1 - (float)(originalLengths.y / l2.mag())));
  print("\n");
  //print((1 - (float)(originalLengths.y / l2.mag())));
  return temp;
}

void draw(){
  background(255, 255, 255);
  directionalLight(255, 255, 255, 1, 1, 0);
  //ambientLight(255,255,255);
  multiplier += .001;
  for(int i = 0; i < lines.size(); i++){
    PVector[] temp = produce_new_vectors(lines.get(i), multiplier, originalLengths.get(i));
    chain(temp, colors.get(i));
  }
}

void chain(PVector[] points, PVector col){
  noStroke();
  fill(col.x, col.y, col.z);
  line(points[0].x, points[0].y, points[0].z, points[1].x, points[1].y, points[1].z);
  line(points[1].x, points[1].y, points[1].z, points[2].x, points[2].y, points[2].z);
  drawWithPoints(points[0], points[1]);

  drawWithPoints(points[1], points[2]);

}


void drawWithPoints(PVector beginning, PVector end){
  pushMatrix();
  translate(beginning.x, beginning.y, beginning.z);
  PVector diff = PVector.sub(end, beginning);
  PVector polar = cartesianToPolar(diff);
  rotateY(polar.y);
  rotateZ(polar.z);
  translate(diff.mag()/2,0,0);
  rotateY(PI/2);

  drawCylinder(10, 2.5, diff.mag());
  popMatrix();
}


void drawCylinder( int sides, float r, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
 
    // draw top of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
 
    // draw bottom of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
 
    // draw sides
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE);
 
}



PVector cartesianToPolar(PVector theVector) {
  PVector res = new PVector();
  res.x = theVector.mag();
  if (res.x > 0) {
    res.y = -atan2(theVector.z, theVector.x);
    res.z = asin(theVector.y / res.x);
  } 
  else {
    res.y = 0;
    res.z = 0;
  }
  return res;
}
