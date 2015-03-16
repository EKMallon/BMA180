import processing.serial.*;

/**
* Artificial Horizon - PROCESSING sketch
*
* View Pitch and Roll angles from an accelerometer of gyro
*
* By krulkip
* Originally developed by TUTO2002 - tuto2002@gmail.com
* Free software distribution
*/

// from http://www.arduino-projects4u.com/bma180/

import processing.serial.*;
Serial myPort; //
PFont myTypeL;
// Conversion factor - Degrees to Radians (2 * PI/360) = 0.01745
float DegToRadians = 0.0174;
int angX = 0;
int angY = 0;
int XA;
int YA;
int XB;
int YB;
int counter=0;
String myString = null;
float num;
int lf = 10; // Linefeed in ASCII
boolean firsttime = true; // Allow time for Arduino to "wake up" in First Cycle
byte start= 0x45; // ASCII - E, dec: 69, hex 45 - Arduino command to "Start" to send data
void setup() {
size(1200, 700);
// The font must be in the "Data" folder
//myTypeL = loadFont("SourceCodePro-Regular.vlw");  //need to put this back in  Trebuchet MS
myTypeL = createFont("Trebuchet MS", 32);
// List all the serial ports available
println(Serial.list());
// On my PC the port used is COM28.
// In your case it may be different

//To find the correct item in the array, run this code in Processing:
//import processing.serial.*;
//import cc.arduino.*;
//println(Arduino.list())
//The output window will enumerate your serial ports. Select the number corresponding to the serial port in your Arduino environment found under Tools > Serial Port.

String portName = Serial.list()[1]; // setting this to 1 selects the second port you see on the list
myPort = new Serial(this, portName, 9600);
myPort.bufferUntil('\n');
myPort.clear();
}
void draw() {
//if (firsttime){
//delay(1000); // If we do not wait for Arduino to "wake up" we will have lost data sent
firsttime = false;
//myPort.write(start); // Send an E to start arduino transmitting data
//delay(100);
//}
read();
background (204);
textFont(myTypeL, 30);
textAlign (CENTER);
fill(0);
text ( " Artificial Horizon" , width/2 , 40);
textFont(myTypeL, 20);
fill(90);//gray
text ( "Pitch º Roll º " ,600 , 660); // Clear the previous data
fill(0,0,159); // Blue
text ( angX ,550 , 660);
text ( angY ,730 , 660);
horizonte (angX,angY);
// For Me Out NO
if (angX < -44){
angX = 40;
}
if (angY > 85){
angY = -85;
}
delay (20);
}
void horizonte (int angleX, int angleY){
rectMode(CORNERS);
stroke(0);
strokeWeight(1);
fill(51,204,204);// Light Blue
rect(400, 150, 800,550);
int cotaY = int(200*tan(angleY *DegToRadians));
int cotaX = int(200*tan(angleX *DegToRadians));
YA= 350-cotaX+cotaY;
YB= 350-cotaX-cotaY;
println ("Antes " + "YA "+ YA + " YB "+ YB );
// NORMAL tilt (NO sideband)
if (YA >= 150 & YA <550) {
XA = 400;
}
if (YB >= 150 & YB <550) {
XB = 800;
}
// We go above or below
if (YA > 550) {
XA = 600 - 200*(200-abs(cotaX))/cotaY;
YA = 550;
println( "Excep 1 ");
}
if (YA < 150) {
XA = 600 - 200*(200-cotaX)/abs(cotaY);
YA = 150;
println( "Excep 2 ");
}
if (YB > 550) {
XB = 600 + 200*(200 +cotaX)/abs(cotaY);
YB = 550;
println( "Excep 3 ");
}
if (YB < 150) {
XB = 600 + 200*(200-cotaX)/abs(cotaY);
YB = 150;
println( "Excep 4 ");
}
// For debugging
println ("XA "+ XA + " YA "+ YA);
println ("XB "+ XB + " YB "+ YB);
println ();
strokeWeight(2);
fill( 153,51,0);
beginShape();
vertex(XA, YA);
if (YA==150){
vertex(400-1,150-1);
}
vertex(400-1,550+1);
vertex(800+1,550+1);
if (YB==150){
vertex(800+1,150-1);
}
vertex(XB,YB);
endShape(CLOSE);
stroke(152,0,0);
strokeWeight(1);
// AXIS
line (400,350,800,350); // Horizontal axis
line (600,150,600,550); // Vertical axix
// Tilt marks
int angleMark = 40;
textFont(myTypeL, 12);
textAlign(LEFT);
fill(204,255,0);
for (int n =0 ; n <4; n++){
int markX = int(200*tan((angleMark-n*10) *DegToRadians));
line (601,350 - markX, 610, 350- markX); // Upper
line (601,350 + markX , 610, 350+ markX); // Lower = X Negative Angles
text ( (angleMark-n*10), 620, 350+6- markX);
text ( -(angleMark-n*10), 620, 350+6+ markX);
}
strokeWeight(4);
noFill ();
ellipse ( 600,350, 392,392); // Outline
// TRIM Surplus
stroke(204);
strokeWeight(10);
ellipseMode(CENTER);
for (int i=1; i < 170; i=i+10){
ellipse ( 600,350, 403+i,403+i);
}
}

void read() {
while (myPort.available() > 0) {
myString = myPort.readStringUntil('\n');
if (myString != null) {
String[] words=split(myString,",");
String test1=" ";
String test2=" ";
for(int i=0;i<words.length;i++)
{
if (i==3) test1=words[i];
if (i==4) test2=words[i];
}

println(test1);
println(test2);
String[] qwerty1=split(test1,"= ");
for(int i=0;i<qwerty1.length;i++)
{
if (i==1) test1=qwerty1[i];
}
println(test1);
println (parseInt(test1));
String[] qwerty2=split(test2,"= ");
for(int i=0;i<qwerty2.length;i++)
{
if (i==1) test2=qwerty2[i];
}
print(test2);
println (parseInt(test2));
angX=(parseInt(test1));angY=-(parseInt(test2));
}
}
}
