// Obliczanie liczby Pi metodą Monte Carlo
// https://pl.wikipedia.org/wiki/Metoda_Monte_Carlo
////////////////////////////////////////////////////////////////////////////

int nst=20000; //Ile losowań na ramkę - 
               //u mnie 15000 daje już prawie maksymalną wydajność
int n=0;  //short n = 0; //Używając typu short można bardzo szybko sprawdzić 
int nk=0; //short nk = 0;//czy działa ZABEZPIECZENIE NA ROZMIAR int'a
double s;

void setup()
{
  size(500,500);
  frameRate(10000);
  noSmooth();//To przyśpiesza mniej więcej 5x
}

void keyPressed()
//Naciśnij dowolny klawisz żeby podejrzeć aktualny wynik
{ //Ile realnie punktów na sekundę i przy jakiej liczbie klatek
  println( "Points Rate:",frameRate*nst," (",frameRate,")");
  println( "Liczba pkt. w kole wynosi: ", (int)nk); 
  println( "Liczba pkt. w kwadracie wynosi: ", (int)n);
  s = 4. * nk /(double)( n );  //Ostateczne obliczenie proporcji
  println( "Liczba pi wynosi: ", s);
}

void draw() //Jest wykonywane w niewidocznej, nieskończonej pętli
{
  for(int i=0;i<nst;i++)//Więcej niż 1 losowanie na ramkę wyświetlania
  {
    float x = random(1.0) * 2 - 1;
    float y = random(1.0) * 2 - 1;
    n++; //kolejna próba 
    
    //ZABEZPIECZENIE NA ROZMIAR int'a
    if(n<0)//PRZEWINĄŁ się int!!!
    {
      n--;//Przewijamy z powrotem
      textSize(18);//Trochę większy font
      text("Pi = " + (4. * ( (double)nk )/( (double) n ) ),0,height);
      noLoop();//Koniec powtarzania pętli draw()
               //Niestety oznacza to też brak reakcji na zdarzenia!
      break;//Przerwanie wewnętrznej pętli
    }
    
    if(x*x + y*y <= 1) //równanie okregu
    {
        nk++;          //punkt wewnątrz
        stroke(255, nk % 256, 0);//kolor czerwono-zółty
    }
    else               //punkt na zewnątrz
    {
        stroke( n % 100 );//kolor ciemno szary
    }
  
    point(x*width,y*height);
  }
}

//https://processing.org/reference/