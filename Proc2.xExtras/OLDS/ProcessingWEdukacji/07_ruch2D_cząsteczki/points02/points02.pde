//"BŁĄDZĄCE PUNKTY" - MODEL RUCHU BROWNA CZĄSTECZEK - BŁĄDZENIE LOSOWE
////////////////////////////////////////////////////////////////////////
int FR=200; //Ile klatek na sekundę
float maxd=3;//Jaki największy ruch 
int Size=100;//Ile cząstek
float[] h=new float[Size];//Położenie pionowe
float[] x=new float[Size];//Położenie poziome

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
  //Wizualizacja w losowym kolorze
  for(int i=0;i<Size;i++)
  {
    stroke(random(255),i,i);//Każdy ma swój kolor ale losowo zmienia odcień
    point(x[i],height-h[i]);
  }
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
    
    x[i]=newx;
    h[i]=newh;
  }
}