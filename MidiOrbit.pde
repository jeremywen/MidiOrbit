/* Ideas
 - maybe holding shift applies changes to all balls, so move mode could change for all
 - more move modes: spiral
 - remember previous midi settings in properties file
 - saving setups
 - allow change of scale mode
 - the pitch could be based on the quadrant that the ball is in
 */
import themidibus.*;
import controlP5.*;
import java.awt.*;

MidiBus midiBus;
String currentMidiDeviceName = "IAC Bus 2";
String[] list_of_devices = MidiBus.availableOutputs();
ControlP5 controlP5;
private int majorScale[] = new int[]{0,2,4,5,7,9,11};
private int minorScale[] = new int[]{0,2,3,5,7,8,10};
int lowestMidiNotePitch = 60;
int nextAvailableCC = 0;
int mouseDownCC = nextAvailableCC++;
PFont font;
BallGroup ballGroup1 = new BallGroup();
BallGroup ballGroup2 = new BallGroup();
int[] colorVals = {100,200,300,50,150,250,350};
int colorValIndex = -1;
String fadeMessage = currentMidiDeviceName;
int fadeCounter = 0;
final int FADE_TIME = 200;
boolean moveAroundPreviousBall = false;
boolean spacePressed = false;
boolean showSecondBallGroup = false;
boolean sendMidiNotes = true;
boolean sendMidiCC = true;
boolean showHelp = false;

void setup() {
  size(400, 400);
  frame.setTitle("MidiOrbit (Press h for Help)");
  smooth();
  ellipseMode(RADIUS);  
  colorMode(HSB,360,100,100);
  midiBus = new MidiBus(this, "", currentMidiDeviceName, "busA");
  font = loadFont("thai.vlw"); 
  ballGroup1.setup();
  ballGroup2.setup();

  controlP5 = new ControlP5(this);
  Controller sendMidiNotesToggle = controlP5.addToggle("sendMidiNotes",sendMidiNotes,100,250,20,20);
  sendMidiNotesToggle.setCaptionLabel("Send Midi Notes");
  sendMidiNotesToggle.setColorForeground(color(200,100,20));
  sendMidiNotesToggle.setColorActive(color(200,100,100));
  
  Controller sendMidiCCToggle = controlP5.addToggle("sendMidiCC",sendMidiCC,200,250,20,20);
  sendMidiCCToggle.setCaptionLabel("Send Midi CC");
  sendMidiCCToggle.setColorForeground(color(200,100,20));
  sendMidiCCToggle.setColorActive(color(200,100,100));
  
  MidiBus.list();
  ScrollableList midiOutList = controlP5.addScrollableList("midiOutList",100,80,200,150);
  for(int i = 0;i < list_of_devices.length;i++) { 
    String deviceName = list_of_devices[i];
    midiOutList.addItem(deviceName,100 + i);
  }
  controlP5.hide();
}

void draw() {
  background(0);
  if(!controlP5.isVisible()){
    if(mousePressed || spacePressed){
      if(mouseButton==LEFT){
        ballGroup1.update(mouseX,mouseY);
        ballGroup1.sendCC();
      }
      else if(mouseButton==RIGHT && showSecondBallGroup){
        ballGroup2.update(mouseX,mouseY);
        ballGroup2.sendCC();
      }
    }
    ballGroup1.display((mousePressed || spacePressed) && mouseButton==LEFT);
    if(showSecondBallGroup)ballGroup2.display((mousePressed || spacePressed) && mouseButton==RIGHT);
    if(keyPressed){
      if(key =='m'){
        setFadeMessage("Mouse Down CC:"+mouseDownCC);
      }
    }
    if(showHelp){
      showHelp();
    }
    if(fadeCounter<FADE_TIME){
      fadeCounter++;
      fill(200,100,map(fadeCounter, 0, FADE_TIME,100,0));
      textFont(font, 10); 
      text(fadeMessage, 0,height);
    }
  } 
  else {
    fill(200,100,100);
    textFont(font, 10); 
    text("Current Midi Out Device:  "+currentMidiDeviceName, 100,50);
  }
}

void mousePressed(){
  if(sendMidiCC && !controlP5.isVisible()) midiBus.sendControllerChange(0, mouseDownCC, 127);
}
void mouseReleased(){
  if(sendMidiCC && !controlP5.isVisible()) midiBus.sendControllerChange(0, mouseDownCC, 0); 
}

void keyReleased(){
  if(key==' '){
    spacePressed = false;
  }
}
void keyPressed(){
  ballGroup1.checkKeyPressed();
  if(showSecondBallGroup)ballGroup2.checkKeyPressed();
  //  println("key="+key+", keyCode="+keyCode+", CODED="+(key == CODED));    
  if(key==CODED){
  } 
  else {
    if(key=='m' && sendMidiCC){
      midiBus.sendControllerChange(0, mouseDownCC, 127);
    } 
    else if(key=='p'){
      moveAroundPreviousBall = !moveAroundPreviousBall;
    } 
    else if(key==' '){
      spacePressed = true;
    }
    else if(key=='u'){
      showSecondBallGroup = !showSecondBallGroup;
    }
    else if(key=='h'){
      showHelp = !showHelp;
    }
    else if(key=='s'){
      if(controlP5.isVisible()){
        controlP5.hide();
      } 
      else {
        controlP5.show();
      }
    }
  }
}

void setFadeMessage(String fadeMessage){
  this.fadeMessage = fadeMessage;
  fadeCounter = 0;
}

void sendMidiNotes(boolean sendMidiNotes){
  this.sendMidiNotes = sendMidiNotes;
}

void sendMidiCC(boolean sendMidiCC){
  this.sendMidiCC = sendMidiCC;
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) {
    int controllerId = (int)theEvent.controller().getValue();
    println(controllerId+" from "+theEvent.controller());
  } 
  else if (theEvent.isGroup()) {
    println(theEvent.group().getValue()+" from "+theEvent.group());
    int controllerId = (int)theEvent.group().getValue();
    if(controllerId>100 && controllerId<200){
      currentMidiDeviceName = list_of_devices[controllerId-100];
      midiBus = new MidiBus(this, "", currentMidiDeviceName, "busA");
    }
  }
}