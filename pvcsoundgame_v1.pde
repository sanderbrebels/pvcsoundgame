import processing.serial.*;
import spacebrew.*;
import cc.arduino.*;
import org.firmata.*;
import processing.sound.*;

SoundFile file;
Arduino arduino;

String server="54.93.57.201";
String name="Sander";
String description ="Client that sends and receives boolean messages. Background turns yellow when message received.";

Spacebrew sb;

color color_on = color(255, 255, 50);
color color_off = color(255, 255, 255);
int currentColor = color_off;
boolean currentButtonValue = false;


void setup() {
  frameRate(240);
  size(500, 400);
  
  println(Arduino.list());
  
  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );
  
  // arduino = new Arduino(this,"/dev/tty.usbmodem1421", 115200);
  arduino = new Arduino(this,"COM3", 57600);
  arduino.pinMode(4, Arduino.INPUT);
  arduino.pinMode(12, Arduino.OUTPUT);
  
  
  // SANDER
  
  sb.addPublish( "button_pressed", "boolean", false );  
    
  sb.addSubscribe( "change_background", "boolean" );
  sb.addSubscribe( "change_LED", "boolean" );
  

  // connect to spacebre
  sb.connect(server, name, description );
  
  file = new SoundFile(this, "C:\\Users\\Sander\\Desktop\\test_knop_processing3_v2\\SnareWav.wav");

}




void draw() {
  // set background color
background( currentColor );
  // draw button
  fill(255,0,0);
  stroke(200,0,0);
  rectMode(CENTER);
  ellipse(width/2,height/2,250,250);
  
  fill(150);
  textAlign(CENTER);
  textSize(24);
   
   if(arduino.digitalRead(4) == Arduino.HIGH) {
     if(currentButtonValue == false) {
     currentButtonValue = true;
      sb.send( "button_pressed", true ); 
         text("That Feels Good", width/2, height/2 + 12);
         arduino.digitalWrite(12, Arduino.HIGH); 
          // file.play();
           
     }
  
   } else {
     if(currentButtonValue == true){
     currentButtonValue = false;
        sb.send( "button_pressed", false );
      text("Click Me", width/2, height/2 + 12);
      arduino.digitalWrite(12, Arduino.LOW);
     }
   }
}



void onBooleanMessage( String name, boolean value ){
  println("got bool message " + name + " : " + value); 

  // update background color
  if (value == true) {
    currentColor = color_on;
    arduino.digitalWrite(12, Arduino.HIGH);
     file.play();
  } else {
    currentColor = color_off;
     arduino.digitalWrite(12, Arduino.LOW);
  }
}







