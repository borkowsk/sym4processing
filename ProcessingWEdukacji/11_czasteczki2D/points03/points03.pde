//"BŁĄDZĄCE PUNKTY" - MODEL RUCHU BROWNA CZĄSTECZEK - BŁĄDZENIE LOSOWE
////////////////////////////////////////////////////////////////////////
int FR=100; //Ile klatek na sekundę
int Size=10000;//Ile cząstek
float maxd=1.5;//Jaki największy ruch (pozycje na float'ach!)
float[] h=new float[Size];//new float;//height/2; //Położenie pionowe
float[] x=new float[Size];//width/2;  //Położenie poziome

void setup() //Jest wykonywane raz - po uruchomieniu. Nie musi być na poczatku kodu ale jest
{
size(500,500);
noSmooth();
for(int i=0;i<Size;i++)
{
  h[i]=random(500);
  x[i]=random(500);
}
background(0,0,200);//rgB
frameRate(FR);
}
              
int count=0;//Licznik klatek obrazu
void draw() //Jest wykonywane w niewidocznej pętli
{
  count++; //Zliczanie klatek
  
  //Właściwy model
  for(int i=0;i<Size;i++)
  {
    float newh=(h[i]+random(maxd*2)-maxd); //Zmień wysokość o mały losowy składnik
    float newx=(x[i]+random(maxd*2)-maxd); //Analogicznie powiększ położenie poziome

    //Odbijamy od ścianek okna! Upraszczamy mechanizm odbicia
    if(newh<0) 
    {
      newh=0;//Trochę oszukujemy - nie może trafić w ścianę
    }
    else
    if(height<newh)
    {
      newh=height;//Trochę oszukujemy
    }
  
    if(newx<0)
    {
       newx=0;//Trochę oszukujemy
    }
    else
    if(width<newx)
    {
       newx=width;//Trochę oszukujemy
    }
    
    //Zmiana pozycji od razu z wizualizacją
    stroke(0,0,200);//Kolor tła
    point(x[i],height-h[i]);
    x[i]=newx;
    h[i]=newh;
    stroke(255,255,i%255);//Każda czątka ma swój odcien
    point(x[i],height-h[i]);
  }  
}
