class Shrek {
  float x,y,vx,vy,vr,r,s;
  float gravity = 1;

  public Shrek(float x, float y) {
    this.x = x;
    this.y = y;
    r = random(0, (float)(2*Math.PI));
    s = random(0.5,2);
    vx = random(-5,5);
    vy = random(-8,2);
    vr = random(0,1);
  }

  public boolean done() {
    return x < -200 || x > width + 200 || y > height + 200;
  }

  public void tick() {
    x += 10*vx;
    y += 10*vy;
    r += vr;
    vy += gravity;
  }

  public void draw() {
    pushMatrix();
    translate(x+shrek.width/2, y+shrek.height/2);
    rotate(r);
    scale(s);
    image(shrek, 0, 0);
    popMatrix();
  }
}
