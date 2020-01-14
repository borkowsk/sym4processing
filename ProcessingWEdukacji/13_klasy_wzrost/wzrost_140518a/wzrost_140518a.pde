//Wzrost losowo z punktu środkowego z mutacjami kolorów
//////////////////////////////////////////////////////////////////////////////////

int Side=500;//Bok macierzy
//RGB to klasa zdefiniowana przez "użytkownika" - dalej w kodzie...
RGB World[][]= new RGB[Side][Side]; //Tablica to też klasa
PrintWriter output;//i PrinterWriter też...

//Klasa do reprezentowania koloru RBG
class RGB
{
  int R,G,B;
  RGB()
  { 
    R=G=B=0; 
    RGB_Counter++;
  }
  void Set(int iR,int iG,int iB)
  {
    R=iR;G=iG;B=iB;
  }
  boolean isEmpty()
  {
    return R<=0 && G<=0 && B<=0;
  }
  void Visualise(int X,int Y)
  {
    if(!isEmpty())
    {
      stroke(R,G,B);
      if(W>1)
      {
        fill(R,G,B);
        rect(X*W,Y*W,W,W);
      }
      point(X*W,Y*W);
    }
  }
}
int RGB_Counter=0;
int W=1; //Mnożnik dla kwadracika



void setup() //Window and model initialization
{
  size(1000,1000);
  W=1000/Side;
  if(W==0) W=1;
  
  World[Side/2][Side/2]= new RGB();
  //World[Side/2][Side/2].Set(64,64,64);
  //World[Side/2][Side/2].Set(128,128,128);
  World[Side/2][Side/2].Set(255,255,255);
  World[Side/2][Side/2].Visualise(Side/2,Side/2);
  
  output = createWriter("Statistics.log");//Create a new file
                                          //in the sketch directory  
  output.println("Step\tCounter");//Write header (Should be 2 columns 
                                  //separeted by tabs)
  noSmooth(); //Fast visualization
  frameRate(50); //maximize speed
}

int Step=0;
boolean Stop=false;
void draw()
//Monte Carlo Step
{
  //Zapis tego co jest
  output.println(Step+"\t"+RGB_Counter); // Write the statistics to the file
  
  //Nowy stan
  if(!Stop)
  {
  int M=Side*Side;
  for(int i=0;i<M;i++)
  {
    int X=int(random(Side));
    int Y=int(random(Side));
    if(World[Y][X]!=null)
    {
       int Xt=X+int(random(3))-1;
       int Yt=Y+int(random(3))-1;
       if(0<=Xt && Xt<Side && 0<=Yt && Yt<Side
          &&  World[Yt][Xt]==null)
        {
          World[Yt][Xt]=new RGB();          //println(Xt,Yt);//DEBUG
          
          int nR=World[Y][X].R+int(random(7))-3;
          if(nR<0) nR=0; else if(nR>255) nR=255;
          int nG=World[Y][X].G+int(random(7))-3;
          if(nG<0) nG=0; else if(nG>255) nG=255;
          int nB=World[Y][X].B+int(random(7))-3;
          if(nB<0) nB=0; else if(nB>255) nB=255;
          
          World[Yt][Xt].Set(nR,nG,nB);     //println(nR,nG,nB);//DEBUG
          World[Yt][Xt].Visualise(Xt,Yt);
          
          //rośnie w zasadzie symetrycznie wiec starczy sprawdzać jeden
          //if(Xt==0 || Yt==0) Stop=true; //Doszło do brzegu z jednej z dwu stron 
          if(Xt==0 && Yt==0) Stop=true; //DOSZŁO DO ROGU
        }  
    }
  }
  Step++;
  }
}