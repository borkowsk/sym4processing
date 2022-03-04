//Ruch po okręgu lub po krzywych Lissajous
//http://pl.wikipedia.org/wiki/Uk%C5%82ad_wsp%C3%B3%C5%82rz%C4%99dnych_biegunowych
//http://pl.wikipedia.org/wiki/Krzywa_Lissajous
///////////////////////////////////////////////////////////////////////////////////////
int FR=1000; //Na ile klatek dzielimy sekundę? Raczej maksymalizujemy to
boolean Cls=false;//Czy czyścić okno w każdej klatce
int sm_r=10;//Promień "kulki"
int bg_R=200;//Promień orbity
float omega=0.005; //Prędkość kątowa na klatkę (krok symulacji)
float phi=0;//Aktualna pozycja na orbicie

float delta=PI*0.25;//Współczynnik kątowy dla krzywej Lissajous 
                    //spłaszcza ją (zobacz PI/4, albo PI/2 robiące linie) i rotuje (sprawdź 0.75 i 1.75)
//float a=1,b=1; //Najprostrza krzywa czyli koło
//float a=1,b=2; //Parabola lub ósemka zależnie od delta
float a=9,b=7;//Współczynniki dla długiej krzywej Lissajous

int xs,ys; //Środek układu współrzędnych biegunowych
void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
ys=height/2;
xs=width/2;
noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
background(0,0,200);//rgB
frameRate(FR);
fill(255,255,0);//Yellow
ellipse(xs,ys,sm_r,sm_r);
}

void draw() //Jest wykonywane dla odrysowania każdej kolejnej klatki
{
  //Rysowanie
  if(Cls) background(0,0,200);
  float x,y; //Aktualna pozycja w układzie kartezjańskim
  x = bg_R * cos(phi*a + delta)+xs;
  y = bg_R * sin(phi*b)+ys;
  fill(255,0,0);//Red
  ellipse(x,y,sm_r,sm_r);
  //Zmiana "stanu"
  phi+=omega;
}
