// ABM minimum template - using template for AGENT BASE MODEL in 1D & 2D discrete geometry
//   >>>>   TYLKO NIEZBĘDNE MODUŁY <<<<
// implemented by Wojciech Borkowski
/////////////////////////////////////////////////////////////////////////////////////////

//PARAMETRY MODELU
int side=75;//DŁUGOŚĆ BOKU ŚWIATA
String modelName="ABMTemplateMin";
float density=0.75;

World TheWorld=new World(side);//... ALE INICJAIZACJA JEST KONCZONA W FUNKCJI setup()

//PARAMETRY WIZUALIZACJI, STATYSTYKI ITP.
int cwidth=15;//DŁUGOŚĆ BOKU KOMÓRKI W WIZUALIZACJI - WARTOSC NADANA TU JEST TYLKO WSTĘPNA
int STATUSHEIGH=40;//WYSOKOŚĆ PASKA STATUSU NA DOLE OKNA

int STEPSperVIS=1;//JAK CZĘSTO URUCHAMIAMY WIZUALIZACJĘ
int FRAMEFREQ=10; //ILE RAZY NA SEKUNDĘ URUCHAMIA SIĘ draw()
//boolean WITH_VIDEO=false;//CZY CHCEMY ZAPIS DO PLIKU FILMOWEGO (wymagany modu… RTMVideo.pde)
boolean simulationRun=true;//FLAGA Start/stop DZIAŁANIA SYMULACJI

void setup()
{
  //GRAFIKA
  size(750,790);//NIESTETY TU MOGĄ BYĆ TYLKO WARTOŚCI PODANE LITERALNIE CZYLI "LITERAŁY"!!!
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //INICJALIZACJA MODELU I (ewentualnie) STATYSTYK
  initializeModel(TheWorld);//ZAKONCZENIE INICJALIZACJI ŚWIATA
  //initializeStats();      //ODKOMENTOWAĆ JEŚLI UŻYWAMY STATYSTYK
  //doStatistics(TheWorld); //J.W.
  
  //OBLICZAMY WYMAGANY ROZMIAR OKNA DLA size() 
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH)/side;//DOPASOWUJEMY ROZMIAR KOMÓREK DO OKNA JAKIE JEST
  
  //INICJALIZACJA ZAPISU FILMU  (jeśli używamy RTMVideo.pde)
  //if(WITH_VIDEO) {initVideoExport(this,modelName+".mp4",FRAMEFREQ);FirstVideoFrame();}
  
  //INFORMACJE KONSOLOWE NA KONIEC FUNKCJI setup()
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height);//-myMenu.bounds.height???
  visualizeModel(TheWorld);//PIERWSZA PO INICJALIZACJI WIZUALIZACJA ŚWIATA
  
  //if(!simulationRun) //WYMAGA MODUŁU RTMEvents.pde
  //  println("PRESS 'r' or 'ESC' to start simulation");
  //else
  //  println("PRESS 's' or 'ESC' to pause simulation");
  
  //NextVideoFrame();//PIERWSZA REALNA KLATKA FILMU (o ile używamy RTMVideo.pde)
}

void draw()
{
  if(simulationRun)
  {
    modelStep(TheWorld);
    //doStatistics(TheWorld);//ODKOMENTOWAĆ JEŚLI UŻYWAMY STATYSTYK
  }
  
  writeStatusLine();
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation should be done from time to time
  {
    visualizeModel(TheWorld);
    //NextVideoFrame();//It utilise inside variable to check if is enabled
  }

}

void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  //textAlign(LEFT, TOP);
  //text(meanDummy+"  "+liveCount,0,side*cwidth);//Miesjce dla NAJWAŻNIEJSZYCH STATYSTYK
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM MAIN TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
