//
/////////////////////////////////////////////////////////////////
int    FPS=16;
String sourdir="/home/borkowsk/data/ZASOBY/FilmyDlaFau/3.66-3.99/";
String core="LoSyn";
String firstFile=core+"00000002";
String ext=".png";
String name=sourdir+firstFile+ext;

PImage photo;

void setup() {
  photo = loadImage(name);
  size(768, 768);
  frameRate(FPS);
  println("Picture: ",name," w*h : ",photo.width," x ",photo.height);
}

int counter=4;
int step=36;
int len=8;
int end=1202;

void draw() {
  image(photo, 0, 0);
  if(width < photo.width || height < photo.height)
  {  
    fill(random(50,255),random(25,255),random(0,255));
    text("Picture too big! w*h : "+photo.width+" x "+photo.height+" in "+name,0,height-3);
  }
  if(counter < end)//Ukryta pętla czytania
  {
    name=sourdir+core+nf(counter,len)+ext;
    //println(name);
    photo = loadImage(name);
    counter+=step;
  }
}