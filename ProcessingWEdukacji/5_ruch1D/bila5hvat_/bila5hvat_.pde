//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=50; //Na ile kroków dzielimy sekundę?

void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
fill(250,250,0);
frameRate(FR);
}

float h=0;
float v=200;//prędkość w pikselach/SEKUNDE (!)
float a=-50;//Przyśpieszenie/hamowanie

void draw() //Jest wykonywane w niewidocznej pętli
{
  //Wizualizacja
  background(0,0,200);//rgB
  ellipse(width/2,height-h,25,25);
  
  //Właściwy model
  v+=a*1/FR; //Powiększ prędkość o zmianę prędkości czyli przyśpieszenie pomnozone przez jednostkę czasu 
  h+=v*1/FR; //Powieksz wysokość o drogę czyli prędkość pomnożąną przez jednostkę czasu
  //print(v,' ');//,h,"; ");
  //print(h," ");
  
  //Nie kadrujemy! Odbijamy od ścianek okna!
  if(h<0 || height<h)//jeżeli h mniejsze od 0 albo h większe niż wysokość okna
    v=-v;//Odwrócenie kierunku prędkości - ROZWIĄZANIE NIEDOSKONAŁE, zmień FR na 30 albo 100 i się przekonaj się szybciej

}