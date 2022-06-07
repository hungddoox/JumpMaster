
final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.3;
final static float JUMP_SPEED = 9.8; 

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

final static float WIDTH = SPRITE_SIZE * 16;
final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 300;
final static float VERTICAL_MARGIN = 400;

//declare global variables
Player p;
PImage tile, snow, crate, ice, brown_brick, player, monster;
ArrayList<Sprite> platforms;
Enemy enemy;
boolean isGameDone;
float view_x = 0;
float view_y = 0;
//int live = 0;

//setup
void setup() {
  size(800, 600);
  imageMode(CENTER);
  
  // p = new Sprite("data/Mario_Big_Right_Still.png", 1);
  PImage player = loadImage("data/Mario_Big_Right_Still.png");
  p = new Player(player, 0.8);
  
  //p.center_x = 100;
  //p.change_y = GROUND_LEVEL;
  
  //enemy = new Enemy(monster, 0.8, 100, 300);
  //p.setBottom(GROUND_LEVEL);
  platforms = new ArrayList<Sprite>();
  
  //enemy = new ArrayList<Sprite>();
  isGameDone = false;

  monster = loadImage("data/Monster.png");
  ice = loadImage("data/ice.png");
  brown_brick = loadImage("data/!.png");
  crate = loadImage("data/block.png");
  snow = loadImage("data/grass.png");
  tile = loadImage("data/tile.png");
  createPlatforms("data/new map 1.csv");
  view_x = 0;
  view_y = 0;
}

// modify and update them in draw().
void draw() {
  background(255);
  scroll();

  //display objects
  displayAll();

  //update objects
  if(!isGameDone){
    checkDeath();    
  }
  
}

void checkDeath() {
  //boolean collideEnemy = checkCollision(p, enemy);
  boolean fallOffCliff = p.getBottom() < GROUND_LEVEL;
  if(fallOffCliff){
    textSize(32);
    fill(255, 0, 0);
    text("YOU WIN!", view_x + width/2 + 50, view_y + height/2);
    text("Press R to RESTART", view_x + width/2 - 25, view_y + height/2 + 50);
    p.lives--;
  }
  /*if(collideEnemy || fallOffCliff){
    p.lives--;
    if(p.lives == 0){
      isGameDone = true;
    } else {
      p.center_x = 100;
      p.setBottom(GROUND_LEVEL);
    }
  }*/
}
 
void displayAll() {
  //enemy display


  //player display and update
  p.display();
  p.updateAnimation();
  
  
  resolvePlatformCollisions(p, platforms);
  for (Sprite s : platforms) {
    s.display();
  }
  //display coin and lives test
  /*
  fill(255, 0, 0);
   textSize(32);
   text("Coin:", view_x + 50, view_y + 50);
   text("Lives:", view_x + 50, view_y + 100);
   */
   
   
  //display when win
  
  if (isGameDone && p.lives == 0) {//checkCollision(p, enemy)
    fill(255, 0, 0);
    text("YOU WIN!", view_x + width/2 + 50, view_y + height/2);
    text("Press R to RESTART", view_x + width/2 - 25, view_y + height/2 + 50);
  }
 }




void scroll() {
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if (p.getRight() > right_boundary) {
    view_x += p.getRight() - right_boundary;
  }

  float left_boundary = view_x + LEFT_MARGIN;
  if (p.getLeft() < left_boundary) {
    view_x -= left_boundary - p.getLeft();
  }

  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if (p.getBottom() > bottom_boundary) {
    view_y += p.getBottom() - bottom_boundary;
  }

  float top_boundary = view_y + VERTICAL_MARGIN;
  if (p.getTop() < top_boundary) {
    view_y -= top_boundary - p.getTop();
  }
  translate(-view_x, -view_y);
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls) {
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  if (col_list.size() > 0) {
    return true;
  } else {
    return false;
  }
}

//map collision
public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_y > 0) {
      s.setBottom(collided.getTop());
    } else if (s.change_y < 0) {
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }


  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_x > 0) {
      s.setRight(collided.getLeft());
    } else if (s.change_x < 0) {
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
} 

//collision
boolean checkCollision(Sprite s1, Sprite s2) {
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if (noXOverlap || noYOverlap) {
    return false;
  } else {
    return true;
  }
}
//collison
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {
    if (checkCollision(s, p)) {
      collision_list.add(p);
    }
  }
  return collision_list;
}


// create map 
void createPlatforms(String filename) {
  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      if (values[col].equals("1")) {
        Sprite s = new Sprite(ice, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("2")) {
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("3")) {
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("4")) {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("5")) {
        Sprite s = new Sprite(monster, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
    }
  }
}

// called whenever a key is pressed.
void keyPressed() {
  if (keyCode == RIGHT) {
    p.change_x = MOVE_SPEED;
  } else if (keyCode == LEFT) {
    p.change_x = -MOVE_SPEED;
  } else if ((key == 'x' || key == 'X' )&& isOnPlatforms(p, platforms)) {
    p.change_y = -JUMP_SPEED;
  } else if (key == 'r'){
   setup();
   }
}

// called whenever a key is released.
void keyReleased() {
  if (keyCode == RIGHT) {
    p.change_x = 0;
  } else if (keyCode == LEFT) {
    p.change_x = 0;
  } /*else if (key == 'x' && isOnPlatforms(p, platforms)) {
   p.change_y = -JUMP_SPEED;
   }*/
}
