//@author Tomás de Camino Beck
//tomasdecamino.com

String[] code;
PFrase[] tombola;
PFont font;
int r;

void setup() {
  size(displayWidth, displayHeight);
  font = loadFont("AmericanTypewriter-64.vlw");
  //**********Data loaded from this file*********
  /*nombres están en fila   */

  code = loadStrings("datos2.txt");


  tombola= new PFrase[code.length];
  for (int i=0; i<code.length;i++) {
    tombola[i]=new PFrase(code[i], width/2-500, height/2+50, font);
  }
  textSize(50);
  textAlign(CENTER);
}


void draw() {
  frameRate(30);
  background(255);
  fill(0, 60);
  //text(code[frameCount%code.length],width/2,height/2);
  for (int i=0; i<code.length;i++) {
    tombola[i].disperseOreturn();
    fill(255, 60);
    stroke(0, 100);
    if (i==r) {
      fill(0, 200);
      tombola[r].display(80);
    }
    tombola[i].checkAttractor(200, 200, 120);
    fill(0, 60);
    tombola[i].display(20);
  }
}

void keyPressed() {

  if (key=='d') {
    r=(int)random(code.length);
    tombola[r].setMode(false);
  } 
  if (key=='a') {
    for (int i=0; i<tombola.length;i++) {
      tombola[i].location.x=width/2-500; 
      tombola[i].location.y=height/2+50;
      tombola[r].setMode(true);
      tombola[r].randomSpeeds();
    }
  }
}

void keyReleased() {
  tombola[r].setMode(true);
  tombola[r].randomSpeeds();
}


//@author Tomás de Camino Beck
//tomasdecamino.com

class PFrase {
  PFrase next;
  PVector location;
  PVector origin;
  PVector velocity;
  PFont font;
  char letter;
  int size =100;
  boolean mode = true;


  PFrase(String str, float x, float y, PFont f) {
    letter =  str.charAt(0);
    font = f;
    textSize(size);
    location = new PVector(x, y);
    origin = new PVector(x, y);
    velocity = new PVector(random(-5, 5), random(-5, 5));
    if (str.length()>1) {
      next = new PFrase(str.substring(1), x+textWidth(letter)/1.3, y, f);
    }
  }

  void display() {
    textFont(font, size);
    text(letter, location.x, location.y);
    if (next != null) {
      next.display();
    }
  }
  
  void display(int s) {
    textFont(font, s);
    text(letter, location.x, location.y);
    if (next != null) {
      next.display(s);
    }
  }  

  void displayLines(float x, float y) {
    textFont(font, size);
    text(letter, location.x, location.y);
    line(origin.x, origin.y, location.x, location.y);    
    if (next != null) {
      //line(x, y, next.location.x, next.location.y);
      next.displayLines(x, y);
    }
  }

  void returnOrigin() {
    location.set(origin);
    velocity.mult(0.01);
    if (next !=null) {
      next.returnOrigin();
    }
  }

  void disperse() {
    location.add(velocity);
    checkEdges();
    if (next !=null) {
      next.disperse();
    }
  }


  void disperseOreturn() {
    if (mode) {
      velocity.rotate(random(-0.5,0.5));
      location.add(velocity);
      checkEdges();
      if (next !=null) {
        next.disperseOreturn();
      }
    }
    else {
      float dx = origin.x - location.x;
      float dy = origin.y - location.y;
      location.add(dx*0.05, dy*0.05, 0);
      if (next !=null) {
        next.disperseOreturn();
      }
    }
  }

  void checkEdges() {
    if (location.x<0) {
      velocity.x*=-1;
      location.set(0, location.y, 0);
    }
    else if (location.x>width) {
      velocity.x*=-1;
      location.set(width, location.y, 0);
    }

    if (location.y < 0) {
      velocity.y*=-1;
      location.set(location.x, 0, 0);
    }
    else if (location.y > height) {
      velocity.y*=-1;
      location.set(location.x, height, 0);
    }
  }

  void randomSpeeds() {
    velocity.set(random(-5, 5), random(-5, 5), 0);
    if (next !=null) {
      next.randomSpeeds();
    }
  }

  void snake() {
    if (next !=null) {
      next.snake();
      next.location.set(location);
    } 
    location.add(velocity);
    checkEdges();
  }

  void setMode(boolean m) {
    mode = m;
    if (next!= null) {
      next.setMode(m);
    }
  }

  void checkAttractor(float x, float y, float th) {
    if (mode) {
      float dx = location.x - x;
      float dy = location.y - y;
      float mag = sqrt(sq(dx)+sq(dy));
      if (mag < th) {
        rect(location.x, location.y, 30, 30,10);
        line(x, y, location.x, location.y);
        velocity.set(random(-5, 5), random(-5, 5), 0);
      }
      if (next!= null) {
        next.checkAttractor(x, y, th);
      }
    }
  }
}
