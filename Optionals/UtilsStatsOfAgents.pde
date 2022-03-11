//Przykład wykonania histogramu z przykładowego pola .A agenta - niestety Processing nie ma szablonów
//więc się nie da tego uogólnić na dowolne pola, a tym bardziej dowolne "światy".
////////////////////////////////////////////////////////////////////////////////////////////

int[] makeHistogramOfA(Agent[][] Ags, //Dwuwymiarowy "świat" agentów - tablica dwuwymiarowa  
                       int N,double Min,double Max,
                       DummyInt Counter, //How many values counted
                       DummyDouble CMin,DummyDouble CMax //MIN i MAX obliczone - do wglądu
                       )

{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX)//Jesli trzeba określić Min i Max
  {
    for(Agent[] Ar: Ags)
      for(Agent  Ag: Ar )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min) Min=val;
        if(val>Max) Max=val;  
      }
    CMin.val=Min;
    CMax.val=Max;
  }
  
  int[] Hist=new int[N];
  
  int Count=0;
  double Basket=(Max-Min)/N;
  //println("Basket width: "+Basket+" MinMax: "+Min+"-"+Max);
   for(Agent[] Ar: Ags)
      for(Agent  Ag: Ar)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}


int[] makeHistogramOfA(Agent[] Ags, //Jednowymiarowy "świat" agentów - tablica   
                       int N,double Min,double Max,
                       DummyInt Counter, //How many values counted
                       DummyDouble CMin,DummyDouble CMax //MIN i MAX obliczone - do wglądu
                       )

{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX)//Jesli trzeba określić Min i Max
  {
      for(Agent  Ag: Ags )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min) Min=val;
        if(val>Max) Max=val;  
      }
    CMin.val=Min;
    CMax.val=Max;
  }
  
  int[] Hist=new int[N];
  
  int Count=0;
  double Basket=(Max-Min)/N;
  //println("Basket width: "+Basket+" MinMax: "+Min+"-"+Max);
      for(Agent  Ag: Ags)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
