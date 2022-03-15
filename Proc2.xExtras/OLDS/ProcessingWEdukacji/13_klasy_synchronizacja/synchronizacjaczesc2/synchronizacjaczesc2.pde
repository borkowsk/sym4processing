class singiel //typ złożony
{
  //pola obiektu czyli dane 
  float x1,x2;
  float r;// wspolczynik kontroli
  float alfa; //jedno z pól, zależne do czego używamy obiektu, tu wartośc sychronizacji
  
  //metody   kazda klasa ma jedna metode ktora nazywa sie jak nazwa klasy
  singiel(float iX,float iR,float iAlfa)// konstruktor nie ma wart zwracanej, nadaje stan obiektowi, wszystkie pola musza miec wartosc nie przypadkowa
  {
    x1=x2=iX; r=iR; alfa=iAlfa;
  }
  //zwykła metoda, czyli zmienia wartosc przynajmniej jednego pola
  void next()
  {
    x1=x2;
    x2=x1*r*(1-x1);
  }
}

  void next4couple(singiel F,singiel S)
  {
    //Wpływ wzajemny na X-y
    F.x2=F.x2*(1-F.alfa)+S.x2*F.alfa;
    S.x2=S.x2*(1-S.alfa)+F.x2*S.alfa;
    //Zmiana stanu
    F.next();
    S.next();
  }
  
//zdefiniowaliśmy klasę, teraz jej użyjemy, wspólczynnik spięcia, synchronizacji
final  float DefaultAlfa=0.1;
int Rozbieg=100;
singiel First, Second;// uchwyty do obiektow, jak zwykła liczba float czy integer, 
                      //to że je zadeklarujemy nie oznacza ze istnieja same obiekty. 
                      //Obiekty powstana dalej, wiec uchwycą dopiero to co powstanie
int Ws=300;

void setup()
{
  size(900,600);//3*Ws , 2* Ws
  
 // First=new singlel // tworzymy nowy obiekt, bedzie typu singiel wpisujem konstrukt singiel
 First=new singiel(random(1.0), 3.5+random(0.5), DefaultAlfa);// 3,5 do 5 bo patrzymy na synchronnizacje w chaosie, wtedy jest najciekawsza
 Second=new singiel(random(1.0), 3.5+random(0.5), DefaultAlfa);//dwaa systey od siebie niezależne, wpływając na alfa możemy zwiekszac ich wzajmna synchronizacje
 
 println("1st:",First.x1+" "+First.r+" alfa:"+First.alfa);//uchwyt do obiektu, robi za nazwe obiektu, kropka i nazwa pola wiec czytamy nazew pola lub mozna z funkcja
 println("2st:",Second.x1+" "+Second.r+" alfa:"+Second.alfa);
}
int N=0;

float G=0;
float B=255;
float Red=255;

float scaleY(double X)
{
  return Ws-(float)X*Ws;
}

void draw()
{
  next4couple(First,Second);
  println("1st:",First.x1,"\t2nd:",Second.x1);
  if(N<2*Ws)
  {
    stroke(Red,0,0,25);
    line(N-1,scaleY(First.x1),N,scaleY(First.x2));//musimy napisac z ktorego obiektu bierzemy x1,x2
    
    stroke(Red,0,0,25);
    line(N-1,scaleY(Second.x1),N,scaleY(Second.x2));
    stroke(0,0,25);
  
    point(N,scaleY(abs(First.x2-Second.x2)));
    point(2*Ws+First.x2*Ws,scaleY(Second.x2));
    
    if(N>Rozbieg)//to wyrzucić to będzie widać doście do atraktora
    {
       ellipse(2*Ws+First.x2*Ws,scaleY(Second.x2),4.0,4.0);
       ellipse(First.x1*Ws,Ws+scaleY(First.x2),4.0,4.0);
       ellipse(Ws+Second.x1*Ws,Ws+scaleY(Second.x2),4.0,4.0);
    }
    
    N++; // tu kończymy wyrzucanie
  }
  else
  {
    N=0;
    println("realFM:",frameRate,"\tX=",First.x1,Second.x2);
    First.x2=random(1.0);
    Second.x2=random(1.0);
    G=random(255);B=random(255);Red=random(255);
  }

}
