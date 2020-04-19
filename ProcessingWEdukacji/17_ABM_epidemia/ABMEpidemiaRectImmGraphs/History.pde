// Wykres zmian w czasie
///////////////////////////////////////////////////////////////

void timeline(FloatList data, float startX, float startY, float height,boolean logaritm)
{
  float   max=-Float.MAX_VALUE;
  int     whmax=-1;//Gdzie jest maksimum
  float   min=Float.MAX_VALUE;
  int     whmin=-1;//Gdzie jest minimum
  int     N=data.size(); //Ile pomiarów
  float  lenght=width-startX;//Ile miejsca na wykres
  
  //Szukanie minimum i maksimum
  for(int t=0;t<N;t++)
  {
    float val=data.get(t);
    if(val>max) { max=val; whmax=t;}
    if(val<min) { min=val; whmin=t;}
  }
  
  if(logaritm)
  {
    max=(float)Math.log10(max+1);//+1 to takie oszustwo 
    min=(float)Math.log10(min+1);//żeby 0 nie wywalało obliczeń
  }
  
  //Właściwe rysowanie
  float wid=lenght/N;//  println(width,N,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  for(int t=0;t<N;t++)
  {
    float val=data.get(t);
    
    if(logaritm)
      val=map((float)Math.log10(val+1),min,max,0,height);    
    else 
      val=map(val,min,max,0,height);
    
    float x=t*wid;
    if(oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val);//println(wid,x-wid,oldy,x,val);
    }
    else
      point(startX+x,startY-val); //println(startX+x,startY-val);
    
    oldy=val;
    
    if(t==whmax || t==whmin)
    {
      textAlign(LEFT,BOTTOM);
      String out=""+data.get(t);
      text(out,startX,startY-val);//Na osi X
      text(out,startX+x,startY-val);//Przy danych
    }
  }
}

//A jakby miało być więcej zmiennych?
//Wtedy np. tak:
//UWAGA! - wspólna skala!!!

void timeline(FloatList a, FloatList b, FloatList c,
              float startx, float starty, float height)
{
  /*
   TODO
  */
}
