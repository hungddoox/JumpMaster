public class Player extends AnimatedSprite {
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  public Player(PImage img, float scale) {
    super(img, scale);
    lives = 1;
    direction = RIGHT_FACING;
    onPlatform = false;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("data/Mario_Big_Left_StillF.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("data/Mario_Big_Right_Still.png");

    jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("data/Mario_Big_Jump_Left.png");

    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("data/Mario_Big_Jump_Right.png");

    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("data/Mario_Big_Left_1.png");
    moveLeft[1] = loadImage("data/Mario_Big_Left_Run_1.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("data/Mario_Big_Right_1.png");
    moveRight[1] = loadImage("data/Mario_Big_Right_2.png"); 
    currentImages = standRight;
  }
  @Override
    public void updateAnimation() {
    onPlatform = isOnPlatforms(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }
  @Override
    public void selectDirection() {
    if (change_x > 0)
      direction = RIGHT_FACING;
    else if (change_x < 0)
      direction = LEFT_FACING;
  }
  @Override
    public void selectCurrentImages() { 
    if (direction == RIGHT_FACING) {
      if (inPlace) {
        currentImages = standRight;
      } else if (!onPlatform) {
        currentImages = jumpRight;
      } else {
        currentImages = moveRight;
      }
    } else if (direction == LEFT_FACING) {
      if (inPlace) {
        currentImages = standLeft;
      } else if (!onPlatform) {
        currentImages = jumpLeft;
      } else {
        currentImages = moveLeft;
      }
    }
  }
}
