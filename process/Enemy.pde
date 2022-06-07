public class Enemy extends AnimatedSprite{
  float boundaryLeft, boundaryRight;
  public Enemy(PImage img, float scale, float bLeft, float bRight){
    super(img, scale);
    standNeutral = new PImage[1];
    standNeutral[0] = loadImage("data/Monster.png"); 
    currentImages = standNeutral;
  }
}
