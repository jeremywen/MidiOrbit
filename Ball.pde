class Ball {
  int x = 0;
  int y = 0;
  int radius = 10;
  int xCC = 70;
  int yCC = 71;
  int xCCVal = 0;
  int yCCVal = 0;  
  int pitch = 0;  
  boolean noteBeingSent = false;
  int colorVal = 100;
  int distanceFromCenter = 50;
  float rotateAngle = -90;
  int rotateRate = 1;//negative reverses direction
  float springGravity = 5;
  float springMass = 2;
  float springStiffness = 0.2;
  float springDamping = 0.7;
  float springVx, springVy; // The x- and y-axis velocities
  int NO_MOVE_MODE = 0;
  int ORBIT_MOVE_MODE = 1;
  int NORTH_SOUTH_MOVE_MODE = 2;
  int EAST_WEST_MOVE_MODE = 3;
  int SPRING_MOVE_MODE = 4;
  int moveMode = 0;
  int index = -1;
  
  public Ball(int index){
    this.index = index;
    xCC = nextAvailableCC++;
    yCC = nextAvailableCC++;
    moveMode = int(random(4)+1);
    println("moveMode="+moveMode);
    distanceFromCenter = int(random(100))+50;
    rotateRate = round(random(10)-5);
    if(rotateRate==0) rotateRate = round(random(5)+1);
    if(index>-1)pitch = getNextMidiNotePitch();
    colorVal = getNextColor();
  }
  
  void display(boolean fillBall){
    if(fillBall){
      fill(colorVal,100,100);
    } 
    else {
      fill(0);
    }
    strokeWeight(noteBeingSent?10:5);
    stroke(colorVal,100,noteBeingSent?100:50);
    ellipse(x, y, radius, radius);
    if(keyPressed && key =='t'){
      showTextNextToBall("Pitch:"+pitch,-5);
      showTextNextToBall("CCX:"+xCC+"  Val:"+xCCVal,5);
      showTextNextToBall("CCY:"+yCC+"  Val:"+yCCVal,15);
    }
  }
  
  void showTextNextToBall(String string, int yOffset){
      fill(200,100,100);
      textFont(font, 10); 
      int xOffset = (x<width/2) ? 15 : -int(textWidth(string))-15;
      text(string, x+xOffset,y+yOffset);
  }

  void update(int x, int y){
    this.x = constrain(x,radius,width-radius);
    this.y = constrain(y,radius,height-radius);
    if(floor(rotateAngle/rotateRate)==0 && moveMode != NO_MOVE_MODE && rotateRate != 0){
      sendNote(getVelocity(), getDuration());
    }
  }

  void moveAroundPoint(int pointX, int pointY){
    if(moveMode == ORBIT_MOVE_MODE){
      int ballX = int(pointX+(cos(radians(rotateAngle))*distanceFromCenter));
      int ballY = int(pointY+(sin(radians(rotateAngle))*distanceFromCenter));
      update(ballX, ballY);
    } else if(moveMode == NORTH_SOUTH_MOVE_MODE){
      int ballY = int(pointY+(sin(radians(rotateAngle))*distanceFromCenter));
      update(pointX, ballY);
    } else if(moveMode == EAST_WEST_MOVE_MODE){
      int ballX = int(pointX+(sin(radians(rotateAngle))*distanceFromCenter));
      update(ballX, pointY);
    } else if(moveMode == SPRING_MOVE_MODE){
      float forceX = (pointX - x) * springStiffness;
      float ax = forceX / springMass;
      springVx = springDamping * (springVx + ax);
      x += springVx;
      float forceY = (pointY - y+5) * springStiffness;
      forceY += springGravity;
      float ay = forceY / springMass;
      springVy = springDamping * (springVy + ay);
      y += springVy;
      update(x, y);
    }
    rotateAngle=(rotateAngle+rotateRate)%360;
  }

  void sendCC(boolean sendX, boolean sendY){
    if(sendMidiCC){
      xCCVal = (int)map(x,radius,width-radius,0,127);
      yCCVal = (int)map(y,radius,height-radius,127,0);
      if(sendX){
        midiBus.sendControllerChange(0, xCC, xCCVal);    
      }
      if(sendY){
        midiBus.sendControllerChange(0, yCC, yCCVal);   
      }
    }
  }
  
  int getVelocity(){
    return (int)map(x,radius,width-radius,0,127)+25;
  }
  
  int getDuration(){
    return (abs(distanceFromCenter)*2)+25;
  }
  
  void sendNote(final int velocity, final int duration){
    if(sendMidiNotes){
      noteBeingSent = true;
      final int midiPitchToSend = pitch;
      Thread thread = new Thread(new Runnable(){
        public void run(){
          int channel = 0;
          midiBus.sendNoteOn(channel, midiPitchToSend, velocity);
          delay(duration);
          midiBus.sendNoteOff(channel, midiPitchToSend, velocity);
          noteBeingSent = false;
        }
      }
      );
      thread.start();
    }
  }
  
  int getNextMidiNotePitch(){
    int scaleIndex = index % majorScale.length;
    int octaveCount = index / majorScale.length;
    int pitch = lowestMidiNotePitch + (octaveCount * 12) + majorScale[scaleIndex];
    return pitch;
  }

  int getNextColor(){
    colorValIndex = (colorValIndex+1)%colorVals.length;
    return colorVals[colorValIndex];
  }  
  
  void checkKeyPressed(){
      if(key=='x'){
        setFadeMessage("Ball "+index+" CCX:"+xCC+"  Val:"+xCCVal);
        sendCC(true, false);
      } 
      else if(key=='y'){
        setFadeMessage("Ball "+index+" CCY:"+yCC+"  Val:"+yCCVal);
        sendCC(false, true);
      }     
      else if(key=='n'){
        setFadeMessage("Note Sent P:"+pitch+" V:"+getVelocity()+" D:"+getDuration());
        sendNote(getVelocity(), getDuration());
      }     
      else if(key=='c'){
        distanceFromCenter-=5;
        setFadeMessage("Ball "+index+" Distance from center: "+distanceFromCenter);
      }     
      else if(key=='f'){
        distanceFromCenter+=5;
        setFadeMessage("Ball "+index+" Distance from center: "+distanceFromCenter);
      }     
      else if(key=='a'){
        rotateRate+=1;
        setFadeMessage("Ball "+index+" Rotate Rate: "+rotateRate);
      }     
      else if(key=='d'){
        rotateRate-=1;
        setFadeMessage("Ball "+index+" Rotate Rate: "+rotateRate);
      }     
      else if(key=='o'){
        changeMoveMode();
        setFadeMessage("Ball "+index+" Move Mode: "+getMoveModeString());
      }     
  }
  
  boolean isMouseOver(){
    return mouseX<x+radius && mouseX>x-radius && mouseY<y+radius && mouseY>y-radius;
  }
  
  void changeMoveMode(){
    moveMode = (moveMode + 1) % 5;
    println(getMoveModeString());
  }
  
  String getMoveModeString(){
    if(moveMode == ORBIT_MOVE_MODE){
      return "Orbit";
    } else if(moveMode == NORTH_SOUTH_MOVE_MODE){
      return "North-South";
    } else if(moveMode == EAST_WEST_MOVE_MODE){
      return "East-West";
    } else if(moveMode == NO_MOVE_MODE){
      return "No Movement";
    } else if(moveMode == SPRING_MOVE_MODE){
      return "Spring Movement";
    }
    return "";
  }
}