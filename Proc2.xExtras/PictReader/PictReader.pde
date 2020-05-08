// PROGRAM CZYTA SERIE PONUMEROWANYCH OBRAZÓW
/////////////////////////////////////////////////////////////////
int    FPS=16;//Ile obrazów na sekundę (jak się dysk wyrobi!)

String sourdir="/home/borkowsk/data/ZASOBY/FilmyDlaFau/3.66-3.99/";//Folder z obrazami
String core="LoSyn";//Rdzeń nazwy
String firstFile=core+"00000002";//Nawza pierwszego pliku
String ext=".png";//ROzszerzenie nazwy

String name=sourdir+firstFile+ext;//Zmontowana pełna ścieżka do pliku

PImage photo=null;//Uchwyt obrazu wczytanego z pliku

void setup() {
  photo = loadImage(name);//Pierwsze wczytywanie
  if(photo==null)
  {
    println("Inaccessible picture: "+name);
    println("; ");
  }
  else
  {
    size(768, 768);
    frameRate(FPS);
    println("Picture: ",name," w*h : ",photo.width," x ",photo.height);
  }
}

int counter=4;
int step=36;
int len=8;
int end=1202;

void draw() {
  if(photo==null) 
  {
    exit();
  }
  else
  {
    image(photo, 0, 0);//Wyświetlanie w oknie
    
    if(width < photo.width || height < photo.height)//Rozmiary okna muszą być dopasowane
    {  
      fill(random(50,255),random(25,255),random(0,255));
      text("Picture too big! w*h : "+photo.width+" x "+photo.height+" in "+name,0,height-3);
    }
    
    if(counter < end)//Ukryta pętla czytania
    {
      name=sourdir+core+nf(counter,len)+ext;// Nowa nazwa
      //println(name);
      photo = loadImage(name);//Kolejne wczytywanie
      counter+=step;
    }
  }
}
