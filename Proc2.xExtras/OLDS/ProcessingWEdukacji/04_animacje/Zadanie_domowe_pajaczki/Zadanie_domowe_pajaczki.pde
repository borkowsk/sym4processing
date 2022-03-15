//OPADAJACE PAJACZKI
////////////////////////////////////////////////////////////////////////
int FR=10; //Ile klatek na sekundę
int Ilu=10;//Ile pajaczkow

float minv=10;//Jaki najmniejszyszy ruch 
float maxv=30;//Jaki największy ruch 
float y0=0;//height/d;

float[] h=new float[Ilu];//height/d;      //Położenie pionowe
float[] x=new float[Ilu];//Random(width); //Położenie poziome - nie będzie się zmieniać
float[] v=new float[Ilu];//minv..maxv     //Prędkość różna

void setup() //Jest wykonywane raz - po uruchomieniu. Nie musi być na poczatku kodu ale jest
{
  size(500,500);
  y0=height/20;
  
  noSmooth();
  frameRate(FR);
  background(0,0,200);//rgB
  stroke(255);
  fill(0);
    
  for(int i=0;i<Ilu;i++)//inicjowanie polozeń i predkości
  {
    h[i]=y0;
    x[i]=random(width);
    v[i]=random(minv,maxv);
    ellipse(x[i],h[i],5,5);
  }
  line(0,y0,width,y0);
}
              
int count=0;//Licznik klatek obrazu
void draw() //Jest wykonywane w niewidocznej pętli
{
  //count++; //Zliczanie klatek - na razie zbędne
  background(0,0,200);//rgB
  line(0,y0,width,y0);
  
  for(int i=0;i<Ilu;i++)//Zmiana polozen
  {
    h[i]+=v[i]/FR;
  }
  
  for(int i=0;i<Ilu;i++)//Rysowanie
  if(h[i]<height-3)
  {
    line(x[i],y0,x[i],h[i]);
    ellipse(x[i],h[i],5,5);
  }
  else
  {
    ellipse(x[i],h[i],7,3);
    v[i]=0;
  }
}
