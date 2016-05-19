class BallGroup {
  int x = 0;
  int y = 0;
  ArrayList otherBalls = new ArrayList();
  int mouseOverBall = -1;

  public BallGroup(){
  }

  void setup(){
    Ball ball0 = new Ball(0);
    Ball ball1 = new Ball(1);
    Ball ball2 = new Ball(2);
    Ball ball3 = new Ball(3);
    Ball ball4 = new Ball(4);

    otherBalls.add(ball0);
    otherBalls.add(ball1);
    otherBalls.add(ball2);
    otherBalls.add(ball3);
    otherBalls.add(ball4);

    ball0.distanceFromCenter=0;
    ball1.distanceFromCenter=50;
    ball2.distanceFromCenter=100;
    ball3.distanceFromCenter=75;

    ball0.moveMode=new Ball(-1).NO_MOVE_MODE;
    ball1.moveMode=new Ball(-1).ORBIT_MOVE_MODE;
    ball2.moveMode=new Ball(-1).NORTH_SOUTH_MOVE_MODE;
    ball3.moveMode=new Ball(-1).EAST_WEST_MOVE_MODE;
    ball4.moveMode=new Ball(-1).ORBIT_MOVE_MODE;

    ball1.rotateAngle=180;
    ball2.rotateAngle=45;
    ball3.rotateAngle=135;
    
    update(width/2,height/2);
  }

  void display(boolean fillBall){
    //    stroke(255);
    //    line(otherBalls[0].x,otherBalls[0].y,otherBalls[0].x,otherBalls[0].y-50);
    for(int i = 0;i<otherBalls.size();i++){
      Ball ball = (Ball)otherBalls.get(i);
      ball.display(fillBall);
    }
  }

  void update(int x, int y){
    Ball ball0 = (Ball)otherBalls.get(0);
    this.x = constrain(x,ball0.radius,width-ball0.radius);
    this.y = constrain(y,ball0.radius,height-ball0.radius);
    ball0.update(this.x, this.y);
    for(int i = 1;i<otherBalls.size();i++){
      Ball ball = (Ball)otherBalls.get(i);
      Ball previousBall = (Ball)otherBalls.get(i-1);
      if(moveAroundPreviousBall || ball.moveMode == 4){
        ball.moveAroundPoint(previousBall.x, previousBall.y);
      } 
      else {
        ball.moveAroundPoint(this.x, this.y);
      }
    }
  }

  void sendCC(){
    for(int i = 0;i<otherBalls.size();i++){
      Ball ball = (Ball)otherBalls.get(i);
      ball.sendCC(true, true);
    }
  }

  void checkKeyPressed(){
    if(key==CODED){
      if(keyCode == 37){//LEFT
      } 
      else if(keyCode == 38){//UP
      } 
      else if(keyCode == 39){//RIGHT
      }
      else if(keyCode == 40){//DOWN
      }    
    } 
    else if(key=='.'){
      int i = (mouseOverBall++ + 1) % otherBalls.size();
      Ball ball = (Ball)otherBalls.get(i);
      setFadeMessage("Mouse over ball "+i);
      moveMouseToBall(ball);
    }
    else if(key=='w'){
      setFadeMessage("All rotate rates increased");
      for(int i = 0;i<otherBalls.size();i++){
        Ball ball = (Ball)otherBalls.get(i);
        ball.rotateRate++;
      }
    } 
    else if(key=='q'){
      setFadeMessage("All rotate rates decreased");
      for(int i = 0;i<otherBalls.size();i++){
        Ball ball = (Ball)otherBalls.get(i);
        ball.rotateRate--;
      }
    }
    else if(key=='r'){
      setFadeMessage("All distances from center increased");
      for(int i = 0;i<otherBalls.size();i++){
        Ball ball = (Ball)otherBalls.get(i);
        ball.distanceFromCenter+=20;
      }
      update(x,y);
    }
    else if(key=='e'){
      setFadeMessage("All distances from center decreased");
      for(int i = 0;i<otherBalls.size();i++){
        Ball ball = (Ball)otherBalls.get(i);
        ball.distanceFromCenter-=20;
      }
      update(x,y);
    } 
    else if(key=='+'){
      Ball newBall = new Ball(otherBalls.size());
      otherBalls.add(newBall);
      update(x,y);
      setFadeMessage("Added Ball. Ball total is now "+otherBalls.size());
    }     
    else if(key=='-' && otherBalls.size()>1){
      otherBalls.remove(otherBalls.size()-1);
      update(x,y);
      setFadeMessage("Subtracted Ball. Ball total is now "+otherBalls.size());
    }    
    else {
      Ball ball = getFirstBallMouseOver();
      if(ball!=null){
        ball.checkKeyPressed();
      }
    }
  }

  int getBallCount(){
    return otherBalls.size();
  }

  Ball getFirstBallMouseOver(){
    for(int i = 0;i<otherBalls.size();i++){
      Ball ball = (Ball)otherBalls.get(i);
      if(ball.isMouseOver()){
        return ball;
      }
    }
    return null;
  }
  
  void moveMouseToBall(Ball ball){
    try { 
      Robot robot = new Robot();
      robot.mouseMove(frame.getLocation().x+ball.x+4, frame.getLocation().y+ball.y+28);
    } 
    catch (AWTException e) {
      e.printStackTrace(); 
    }    
  }
}