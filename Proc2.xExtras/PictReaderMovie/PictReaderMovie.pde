// Free code Movie Maker designed by Wojciech Borkowski
/////////////////////////////////////////////////////////////////
import java.nio.file.*;//files.exists();
int    FPS=25;
String sourdir="/home/borkowsk/data/ZASOBY/FilmyDlaFau/3.66-3.88chyba/";
//"/home/borkowsk/data/ZASOBY/FilmyDlaFau/alfabet3/";
//"/home/borkowsk/data/ZASOBY/FilmyDlaFau/games6/";
//"/home/borkowsk/data/ZASOBY/FilmyDlaFau/3.5-4/";
String core="LoSyn00";
//"Alfabet v0.935";
//"GAmES-1995-REviSitED500 x 500 Moore4_1501798567-24353_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore4_1501798375-24327_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore4_1501798375-24327_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore4_1501798141-24295_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore4_1501788051-22953_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore3_1501758501-19288_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore2_1501725173-15142_lcg_rand_singleth";
//"GAmES-1995-REviSitED500 x 500 Moore1_1501670008-8232_lcg_rand_singleth";
//"GAmES-1995-REviSitED450 x 450 Moore1_1501668619-8042_lcg_rand_singleth";
//"GAmES-1995-REviSitED450 x 450 Moore1_1501633427-4047_lcg_rand_singleth";

//"LoSyn";
String firstFile=core+"000000";//"0000002"
String ext=".png";
String name=sourdir+firstFile+ext;

PImage photo;

void setup() {
  photo = loadImage(name);
  size(768,768);
  frameRate(FPS);
  println("Picture: ",name," w*h : ",photo.width," x ",photo.height);
  println("Start video export");
  initVideoExport(this,sourdir+core+photo.width+"x"+photo.height+"fps"+FPS+"e"+end+"."+step+".mp4",FPS);//Aktywacja zrzutu wideo
  firstVideoFrame(255,255,1);//Not 0! 
  println("Setup complete");
}

int counter=2;
int step=16;
int len=6;
int end=6500;

void draw() 
{
  if(photo!=null) 
  {
    image(photo, 0, 0);
    if(width < photo.width || height < photo.height)
    {  
      fill(random(50,255),random(25,255),random(0,255));
      //text("Picture too big! w*h : "+photo.width+" x "+photo.height+" in "+name,0,height-3);
    }
  }
  
  if(counter < end)//Ukryta pętla czytania
  {
    if(photo!=null) 
          nextVideoFrame();//Video frame to movie
          
    name=sourdir+core+nf(counter,len)+ext;
    
    counter+=step;//For next file
    print("TRY IMAGE:",counter);
         
    if(Files.exists(Paths.get(name),new LinkOption[]{ LinkOption.NOFOLLOW_LINKS}) )//http://tutorials.jenkov.com/java-nio/files.html#files-exists
    {
     photo = loadImage(name);
     println(" *");
     if(frameCount % FPS==0) 
         println("Prosessing speed is ",frameRate," img/s");
    }
    else 
    {
      photo=null;
      println(" ?");
    }    
  }
  else
  {
   int TSize=height/30;
   textSize(TSize);
   fill(255,random(0,255),0);
   textAlign(CENTER);
   text("Prepared at koko@fau.edu by A.Nowak [nowak@fau.edu]  & ",width/2,height-TSize*3);
   text("W.Borkowski [wborkowski@uw.edu.pl]",width/2,height-TSize*2);
  }
}
    /*
    try{  //TO NIE CHCE DZIAŁAĆ - I TAK SIĘ ZATRZYMUJE
      println("TRY READER:");
      BufferedReader reader=createReader(name);
      reader.close();
    }catch(Exception e)
    {
      println("Something wrong with ",name);
      e.clear();
      photo = null;
      return; //!!!
    } */
    



void exit() //it is called whenever a window is closed. 
{
  noLoop();   // For to be sure...
  delay(100); // it is possible to close window when draw() is still working!
  closeVideo();
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
} 