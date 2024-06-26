//Wzrost losowo z punktu środkowego z mutacjami kolorów
//////////////////////////////////////////////////////////////////////////////////
//uzywamy KLASY zdefiniowanej przez użytkownika o nazwie RGB

//Parametry modelu  
int JUMP=3;//skok pozycji "zarodnika". Nieparzysty!
int CJUMP=15;//skok koloru. Tez lepiej nieparzysty.
int STARTG=128;//W jakiej szarości pierwsza komórka

//Ważne globalne zmienne, ale inicjowane w setup()
int Side;//Bok macieży
int W; //Mnożnik dla kwadracika
RGB World[][];//TABLICA

PrintWriter output;//A tu używamy KLASY zdefiniowanej w bibliotece

void setup() //Window and model initialization
{
  size(900,900);
  W=2;
  Side=900/2;

  World = new RGB[Side][Side];
  World[Side/2][Side/2]= new RGB();

  World[Side/2][Side/2].Set(STARTG,STARTG,STARTG);//Inicjalize 
  World[Side/2][Side/2].Visualise(Side/2,Side/2);
  
  output = createWriter("Statistics.log"); // Create a new file in the sketch directory  
  output.println("Step\tCounter");
  
  noSmooth(); //Fast visualization
  frameRate(30); //maximize speed
}

int Step=0;
boolean Stop=false;
void draw()
//Monte Carlo Step
{
  //Zapis tego co jest
  output.println(Step+"\t"+RGB_Counter); // Write the statistics to the file
  output.flush();
  
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
         int Xt=X+int(random(JUMP))-JUMP/2;
         int Yt=Y+int(random(JUMP))-JUMP/2;
         
         if(0<=Xt && Xt<Side && 0<=Yt && Yt<Side
            &&  World[Yt][Xt]==null)
          {
            World[Yt][Xt]=new RGB();
            int nR=World[Y][X].R+int(random(CJUMP))-CJUMP/2;
            if(nR<0) nR=0; else if(nR>255) nR=255;
            
            int nG=World[Y][X].G+int(random(CJUMP))-CJUMP/2;
            if(nG<0) nG=0; else if(nG>255) nG=255;
            
            int nB=World[Y][X].B+int(random(CJUMP))-CJUMP/2;
            if(nB<0) nB=0; else if(nB>255) nB=255;
            
            World[Yt][Xt].Set(nR,nG,nB);
            World[Yt][Xt].Visualise(Xt,Yt);
            
            if(Xt==0 || Yt==0)//Doszło do brzegu z jednej z dwu stron - a rośnie w zasadzie symetrycznie
                  Stop=true; 
          }  
    }
  }
  Step++;
  }
}
