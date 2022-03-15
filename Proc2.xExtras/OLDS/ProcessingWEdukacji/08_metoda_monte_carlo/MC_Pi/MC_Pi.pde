// Obliczanie liczby Pi metodą Monte Carlo
// https://pl.wikipedia.org/wiki/Metoda_Monte_Carlo
//////////////////////////////////////////////////////////////////
int n = 0;  //Ile w ogóle punktów
int nk = 0; //Ile punktów trafiło w koło

void setup()
{
  size(500,500);
  frameRate(10000);//Próbujemy wymusić jak największą częstość wywołań draw()
}

void keyPressed()
//Naciśnij dowolny klawisz żeby podejrzeć aktualny wynik
{
  println( "Points Rate:",frameRate);//Ile realnie punktów na sekundę
  println( "Liczba pkt. w kole wynosi: ", nk);
  println( "Liczba pkt. w kwadracie wynosi: ", n);
  double s = 4. * nk /(double)( n );
  println( "Liczba pi wynosi: ", s);
  
}

void draw() //Jest wykonywane w niewidocznej, nieskończonej pętli
{
    float x = random(1.0) * 2 - 1;
    float y = random(1.0) * 2 - 1;
    n++; //kolejna próba
        
    if(x*x + y*y <= 1) //równanie okregu
    {
        nk++;          //punkt wewnątrz
        stroke(255,random(255),0);//kolor czerwono-zółty
    }
    else               //punkt na zewnątrz
    {
        stroke(random(100));//kolor ciemno szary
    }
  
    point(x*width,y*height);
}