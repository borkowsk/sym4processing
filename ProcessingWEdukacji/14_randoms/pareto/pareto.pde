//Program dop testowania różnych sposobów losowania
/////////////////////////////////////////////////////////
// https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution
/////////////////////////////////////////////////////////

double MyRandom0()
{
  return random(0,1);//Random z Processingu
  //zamiast można zastosować inne generatory 
}

//XOR SHIFT random generator - flat distribution
//http://www.javamex.com/tutorials/random_numbers/xorshift.shtml#.WT6NEzekKXI
long xl=123456789L;
double mianownik=(double)9223372036854775807L; //9,223,372,036,854,775,807 <--- max long 
double MyRandom2() 
{
  xl ^= (xl << 21);
  xl ^= (xl >>> 35);
  xl ^= (xl << 4);
  return (Math.abs(xl)/mianownik);
}

//Pareto distribution from flat distribution
//https://math.stackexchange.com/questions/1777367/how-to-generate-a-random-number-from-a-pareto-distribution
  double a = 41.4104*(1-0.01);//Kształt- im większe tym ostrzej skośny rozkład
  double b =  6.82053374;//Skalowanie - im większe tym większy zakres. Wartość 6.n dobrana do zakresu 0..1
  double limit = 1;//Akceptujemy tylko wartości od 0 do limit. Większe powodują ponowne losowanie
  
double MyRandomPareto()
{
  double rndval;
  do 
  { 
   rndval = MyRandom2();//drand48() ?
   //rndval = 1-rndval;//PO CO?
   double inv_fun_denom = Math.pow(1-rndval , 1/a);
   rndval = (b/inv_fun_denom)-b; //adding the -b did the trick //<>//
  }while(rndval>limit);//Akceptujemy tylko wartości od 0 do limit
  return rndval;
}

double MyRandomM()
{
  return Math.random()*Math.random()*Math.random()*Math.random()*Math.random()*Math.random();//Mnożenie 6 rozkladów
}

int NumOfBaskets=7;
int Basket[]=new int[NumOfBaskets+1];
int N=0; //Licznik losowań

//Do sensownej wizualizacji
int ReqFrames=10;//Ile ramek na sekundę chcemy
int NumOfProbesPerDraw=100;//Ile losowań w jednej ramce
int MaxBasket=100;//Do skalowania słypków. Początkowo coś musi być. 

void setup()
{
  size(1000,500);
  frameRate(ReqFrames);
  for(int i=0;i<=NumOfBaskets;i++)//Resetowanie koszyków
           Basket[i]=0;
}

void draw()
{
  //Trochę losowań
  for(int s=0;s<NumOfProbesPerDraw;s++)
  {
    double rndval=MyRandomPareto();//MyRandom1();//Powinno być w zakresie 0..1
    
    //Testowanie spełnienia założenia. W C++ byłoby może assert()
    if(rndval<0) { println("Niemożliwe!!! rndval=",rndval); continue;}
    if(rndval>1) { println("Coś za dużo :-) rndval=",rndval); continue;}
    
    //Do którego to koszyka?
    int i=(int)(rndval*NumOfBaskets);
    if(i>NumOfBaskets)
        i=NumOfBaskets; //Zabezpieczenie
    
    Basket[i]++;    //Doliczenie
    N++;
  }
  
  background(255);//Czyszczenie ekranu
  VisualiseBaskets();//Rysowanie histogramu
}

void VisualiseBaskets()//Rysowanie słupków
{
  for(int i=0;i<=NumOfBaskets;i++)//Aktualizacja maksimum
  if(Basket[i]>MaxBasket)
        MaxBasket=Basket[i];
 
  int StartX=width/10;//10% po obu stronach okna zostawiamy 
  int StartY=height/10;
  int WidthH=StartX*8;//użytkowa szerokość histogramu
  int HeighH=StartY*8;//... i wysokość
  int StepX=WidthH/(NumOfBaskets+1);//Szerokość jednego słupka
  
  for(int i=0;i<=NumOfBaskets;i++)
  {
    fill(255,0,255*Basket[i]/MaxBasket);//Wizualizacja kolorem
    rect(StartX+i*StepX,StartY+HeighH,StepX,-(HeighH*Basket[i]/MaxBasket));
  }
  fill(0);
  textSize(16);
  text("Max="+MaxBasket,0,StartY);
  text("0",StartX,StartY+HeighH+16);
  text("1",StartX+NumOfBaskets*StepX,StartY+HeighH+16);
  text("N="+N,StartX+WidthH,StartY+HeighH+16);
}
