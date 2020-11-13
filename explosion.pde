ArrayList<PVector[]> lines;
PVector[] colors = new PVector[3];
float multiplier = 1.0;

void setup(){
  size(1920,1080, P3D);
  lines = new ArrayList<PVector[]>();
  for(int i = 0; i < 3; i++){
    colors[i] = new PVector(random(0,255), random(0,255), random(0, 255));
  }
 
  PVector[] points = {
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400)) 
  };
  lines.add(points);
  PVector[] points1 = {
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400))
  };
  lines.add(points1);
  PVector[] points2 = {
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400)), 
    new PVector(random(0,1920), random(0,1080), random(-400, 400))
  };
  lines.add(points2);
  
}

void draw(){
  background(255, 255, 255);
  directionalLight(255, 255, 255, 1, 1, 0);
  //ambientLight(255,255,255);
  multiplier += .0005;
  int count = 0;
  for(PVector[] i : lines){
    PVector[] temp = {PVector.mult(i[0], multiplier), PVector.mult(i[1], multiplier), PVector.mult(i[2], multiplier)};
    chain(temp, colors[count]);
    count += 1;
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

  drawCylinder(10, 25, diff.mag());
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
