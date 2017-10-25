import ddf.minim.*;
import processing.serial.*;

String arduino = "COM8";//connects arduino and processing
Serial serial;
Minim minim;
AudioPlayer wallSound, batSound;
PImage ball, bat, back;
float leftBatPosition, rightBatPosition;
float ballX, ballY;
float vertSpeed, horiSpeed;
int serveDirection = 1;
int leftScore = 0;
int rightScore = 0;
//boolean Adown, Zdown, Pdown, Ldown;


void setup()
{
  size(960,720);//size of game screen
  imageMode(CENTER);
  textSize(40);
  connectArduino();
  ball = loadImage("ball.png");
  bat = loadImage("bat.png");
  back = loadImage("back.png");
  minim = new Minim(this);
  wallSound = minim.loadFile("wall.mp3");
  batSound = minim.loadFile("bat.mp3");
  leftBatPosition = bat.height/2;
  rightBatPosition = bat.height/2;
  resetBall();
  frameRate(25);
}

void draw()
{
  image(back,width/2,height/2,width,height);
  
  // Draw the scores
  text(""+leftScore,width/4,120);
  text(""+rightScore,3*(width/4),120);
  text("p1", width/4,50);
  text("p2", 3*(width/4),50);
  frame.setTitle("Ping Pong Game");
  
  

            
  
  //line(width/2,0,width/2,height);
stroke(255);  
//int x1 = 15;
//int y1 = 10;
//int x2 = 80;
//int y2 = 90;
//line(x1, y1, x2, y2);
for (int i = 0; i <= height; i++) {
  float x = width/2;
  float y = lerp(0, height, i/80.0);
  point(x, y);
}
 
  //for(int i = 0;i<height;i++){
  //  if(i%2==1) stroke(255);
  //  else stroke(0);
  //  line(width/2,0,width/2,height);
      
      
  //   }
  
  
  
 
  
        
 
      

  // Move and the bats
  if((serial != null) && (serial.available()>0)) {
    String message = "";
    while(serial.available()>0) message = serial.readStringUntil('\n');
    if(message != null) {
      String[] data = message.split(" ");
      if(data.length == 2) {
        float left = map(int(data[0].trim()),0,1024,0,height);
        float right = map(int(data[1].trim()),0,1024,0,height);
        leftBatPosition = lerp(leftBatPosition,left,0.25);
        rightBatPosition = lerp(rightBatPosition,right,0.25);
      }
    }
  }
  
    //if(Adown) leftBatPosition-=10;
    //if(Zdown) leftBatPosition+=10;
    //if(Pdown) rightBatPosition-=10;
    //if(Ldown) rightBatPosition+=10;

  // Draw the left bat
  translate(bat.height,leftBatPosition);
  rotate(HALF_PI);
  image(bat,0,0);
  rotate(-HALF_PI);
  translate(-bat.height,-leftBatPosition);

  // Draw the right bat
  translate(width-bat.height,rightBatPosition);
  rotate(-HALF_PI);
  image(bat,0,0);
  rotate(HALF_PI);
  translate(-(width-bat.height),-rightBatPosition);

  // Calculate new position of ball - being sure to keep it on screen
  ballX = ballX + horiSpeed;
  ballY = ballY + vertSpeed;
  if(ballY >= height) wallBounce();
  if(ballY <= 0) wallBounce();
  if(ballX >= width+20) {
    if(leftScore<3){
    
    leftScore++;
    resetBall();
  }
    else if(leftScore==3){
    text("p1 wins!", (width/4),height/2);
    }
    
    
  }
  if(ballX <= -20) {
    if(rightScore<3){
    
    rightScore++;
    resetBall();
  }
    else if(rightScore==3){
    text("p2 wins!", 3*(width/4),height/2);
    }
  }
  
  // Send ball position to arduino every 4th frame (to reduce comms)
  if((frameCount % 4 == 0) && (serial != null)) {
    int angle = int(map(ballX,0,width,90,0));
    serial.write(int(angle));
  }
  
  // Draw the ball in the correct position and orientation
  translate(ballX,ballY);
  float theta = atan(abs(horiSpeed)/abs(vertSpeed));
  if((vertSpeed>0) && (horiSpeed>0)) rotate(-theta);
  else if((vertSpeed>0) && (horiSpeed<0)) rotate(theta);
  else if((vertSpeed<0) && (horiSpeed>0)) rotate(theta-PI);
  else if((vertSpeed<0) && (horiSpeed<0)) rotate(PI-theta);
  image(ball,0,0);
  
  // Do collision detection between bat and ball
  if(leftBatTouchingBall()) hitBall(leftBatPosition-ballY);
  if(rightBatTouchingBall()) hitBall(rightBatPosition-ballY);
      
}

void resetBall()
{
  ballX = width/2;
  ballY = height/2;
  vertSpeed = random(-10,10);//-15,15
  horiSpeed = serveDirection * 10;//15
  serveDirection = -serveDirection;
}

boolean leftBatTouchingBall()
{
  float distFromBatCenter = leftBatPosition-ballY;
  return (ballX < (bat.height*2)) && (ballX > (bat.height/2)) && (abs(distFromBatCenter)<bat.width/2);
}

boolean rightBatTouchingBall()
{
  float distFromBatCenter = rightBatPosition-ballY;
  return (ballX > width-(bat.height*2)) && (ballX < width-(bat.height/2)) && (abs(distFromBatCenter)<bat.width/2);
}

void hitBall(float spin)
{
  horiSpeed = -horiSpeed;
  ballX += horiSpeed;
  vertSpeed = -spin/10;
  batSound.rewind();
  batSound.play();
}

void wallBounce()
{
  vertSpeed = -vertSpeed;
  wallSound.rewind();
  wallSound.play();
}

void connectArduino()
{
  try {
    serial = new Serial(this, arduino, 9600);
  } catch(Exception e) {
  }
}

void stop()
{
  serial.stop();
}