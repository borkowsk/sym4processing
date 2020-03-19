//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - BŁĄDZENIE LOSOWE
//////////////////////////////////////////////////////////////////
int FR=20; //Na ile kroków dzielimy sekundę?
float h=height/2; //Położenie pionowe
float x=width/2;  //Położenie poziome
float vh=0;  //aktualna prędkość pionowa w pikselach/SEKUNDE (!)
float vx=0;  //aktualna prędkość pozioma
float maxV=100;//Maksymalna prędkość poziomo lub pionowa do wylosowania
float B=0.90; //Wydajność odbicia sprężystego 
              //1-B = ile energi kinetycznej się rozprasza nie wraca do prędkości po odbiciu

void setup() //Jest wykonywane raz - po uruchomieniu. Nie musi być na poczatku kodu ale jest
{
size(500,500);
h=height/2; x=width/2;
background(0,0,200);//rgB
frameRate(FR);
}
              
int count=0;//Licznik klatek obrazu
void draw() //Jest wykonywane w niewidocznej pętli
{
  //Wizualizacja w losowym kolorze
  fill(random(250),random(250),0);
  stroke(random(250),random(250),0);
  ellipse(x,height-h,25,25);
  count++; //Zliczanie klatek
  
  //Właściwy model
  if( count % FR == 0 ) //Dokładnie raz na sekundę zmienia wektor prędkości
  {
    vh=random(-maxV,maxV); 
    vx=random(-maxV,maxV); 
  }
  
  h+=vh*1/FR; //Powieksz wysokość o drogę czyli prędkość pomnożąną przez jednostkę czasu
  x+=vx*1/FR; //Analogicznie powiększ położenie poziome

  //Odbijamy od ścianek okna! Upraszczamy mechanizm odbicia
  if(h<0) 
  {
    vh=-vh*B;
    h=0; //Trochę oszukujemy
  }
  else
  if(height<h)
  {
    vh=-vh*B;
    h=height;//Trochę oszukujemy
  }
  else //A jakby to wykomentować? ;-)
  if(x<0)
  {
     vx=-vx*B;
     x=0;//Trochę oszukujemy
  }
  else
  if(width<x)
  {
     vx=-vx*B;
     x=width;//Trochę oszukujemy
  }
}