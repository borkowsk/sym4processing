import ddf.minim.*; //http://code.compartmental.net/tools/minim/manual-minim/

Minim minim;
AudioInput in;
AudioRecorder fout; //How to make it modal?

// JAXB is part of Java 6.0, but needs to be imported manually
import javax.xml.bind.*; //From: http://wiki.processing.org/w/XML_parsing_with_JAXB 
AppConfig config; // our little data class for storing config settings - this class is defined in its own tab in the Processing PDE

int winwidth=800;
int winheigh=600;
int back=0;   //0x1EBFEF; kolor tła
int targ=0;  //0x60; kolor środkowej kulki
int textc=0; //kolor tekstu
int siztx=32;//rozmiar czcionki
int rate=1;
int maxtime=10;
boolean mousestop=false;
String breakchars="";//Normalnie nie ma więc nie da się przerwać
String outfilename="myrecording.wav";
String message="";
 
boolean sketchFullScreen() {  //TO JEST URUCHAMIANE JESZCZE PRZED setup()'em
  return true;
}

void setup() //Czytanie konfiguracji z pliku config.xml i jej realizacja
{
  // the following 2 lines of code will load the config.xml file and map its contents
  // to the nested object hierarchy defined in the AppConfig class (see below)
  try {
    // setup object mapper using the AppConfig class
    JAXBContext context = JAXBContext.newInstance(AppConfig.class);
    // parse the XML and return an instance of the AppConfig class
    
    //Is passing parametres possible?
    println("args length is " + args.length);
    for(int a=0;a<args.length;a++)
      println(args[a]);
      
    InputStream input = createInput("sregconfig.xml");
    if(input==null)
    {
      println("Where is my sregconfig.xml file?");
      System.exit(1);
    }
    
    config = (AppConfig) context.createUnmarshaller().unmarshal(input);
    //Reading parameters
    winwidth=config.width;
    winheigh=config.height;
    siztx=config.textsize;
    textc=unhex(config.textcolor);
    back=unhex(config.bg);
    //println(config.bg+"-->"+back);
    targ=unhex(config.target);
    //println(config.target+"-->"+targ);
    if(!config.outfile.equals(""))
      outfilename=config.outfile;
    //println(config.outfile+"-->"+outfilename);
    if(config.maxtime>=0)
      maxtime=config.maxtime;
    if(config.rate>0)
      rate=config.rate;
    if(!config.breakchars.equals(""))
      breakchars=config.breakchars;
    //println(config.breakchars+"-->"+breakchars);  
    mousestop=config.breakmouse;
    if(!config.message.equals(""))
      message=config.message;
    if(maxtime<=0 && !mousestop && config.breakchars.equals("") ) //gdyby nie było sposobu na zatrzymanie
    {
      message+="\n No time limit. Click mouse to stop";
      mousestop=true;
    }  
  } catch(JAXBException e) {
    // if things went wrong...
    println("error parsing config.xml: ");
    e.printStackTrace();
    // force quit
    System.exit(2);
  }
  
  if(winwidth<=0) //Jeśli nie ustawione inaczej
    winwidth=displayWidth; //To największe możliwe
  if(winheigh<=0) //Jeśli nie ustawione inaczej 
    winheigh=displayHeight; //To największe możliwe
    
  size(winwidth,winheigh);
  frameRate(rate);// "rate" klatek/sek
  
  if(back>0)
    background(back); //KOLOR TŁA OKNA Z PLIKU XML
  else
    background(0x1E,0xBF,0xEF); //DOMYŚLNY KOLOR TŁA OKNA
 
  minim = new Minim(this);
 
  // get a stereo line-in: sample buffer length of 512
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  // get a recorder that will record from in to the 
  // filename specified using buffered recording
  fout = minim.createRecorder(in,outfilename, true);
  fout.beginRecord();
}
 

int curstep=0;//Która klatka czy też (domyślnie) sekunda nagrywania 
void draw()   //odświerzanie ekranu i liczenie czasu
{
  curstep++; //NEXT TIME STEP
  //Napis
  if(!message.equals(""))
  {
     background(unhex(config.bg));
     textAlign(CENTER);
     textSize(siztx);
     fill(textc);
    // display  message
     text(message,width/2,height/10);
  }
  
  //KROPKA NA ŚRODKU
  //stroke(targ);
  stroke(0);
  fill(targ);
  ellipse(winwidth/2,winheigh/2,winheigh/20,winheigh/20);
  stroke(128);
  //PASEK POSTĘPU
  if(maxtime>0)
  {
    fill(255,255,255);
    rect(winwidth/3,winheigh/20*19-6,winwidth/3,winheigh/20+6);
    fill((int)(255* pow(curstep,10) / pow(maxtime,10) ),0,0);
    rect(winwidth/3,winheigh/20*19-3,(curstep*winwidth)/(3*maxtime),winheigh/20);
  }
  
  //PRZERWANIE PO LIMICIE CZASU
  if(maxtime>0 && curstep>maxtime)
  {
    print("TIME");
    noLoop();
    stop();
    super.exit();
  }
}
 
void keyPressed() //http://processing.org/discourse/beta/num_1244576974.html
{  
  // Prevent direct exit from Escape key
  if (key == 27) 
    key = 0;
}

void keyReleased()
{
  // PRZERWANIE NA KLIKNIECIE NA KLAWIATURZE PRZEZ BADANEGO
  //print(key+" #"+int(key));
  if(breakchars.indexOf(key)>=0) //czy znalazł?
  {
    print("KEY"+int(key));
    noLoop();
    stop();
    super.exit();
  }
}

void mouseReleased()
{
  if(mousestop)
  {
   // PRZERWANIE NA KLIKNIECIE MYSZKĄ PRZEZ BADANEGO
   noLoop();
   stop();
   super.exit();
  }
}
 
void stop() //NIE WYWOŁUJE SIĘ AUTOMATYCZNIE, A CHYBA TAKI BYŁ ZAMYSŁ W PRZYKŁADZIE
{
  print("STOP");
  // shoud save recorded speech
  fout.endRecord(); 
  fout.save(); //NIBY ZAPISUJE, ale nie wszystkie programy to odczytuja. Może Windowsy zmieniły format?
  
  // always close audio I/O classes
  in.close();
  // always stop your Minim object
  minim.stop();

  super.stop();
}
